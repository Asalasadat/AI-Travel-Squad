from pathlib import Path
from typing import Literal
 
import joblib
import numpy as np
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
 
from recommender import get_recommendations
 
BASE_DIR = Path(__file__).parent
 
# ---------------------------------------------------------------------------
# Load the serialized model artifacts + dataset ONCE at startup
# ---------------------------------------------------------------------------
encoder = joblib.load(BASE_DIR / "models" / "tourism_encoder.pkl")
feature_matrix = np.load(BASE_DIR / "models" / "feature_matrix.npy")
places_df = pd.read_csv(
    BASE_DIR / "data" / "palestine_tourist_attractions_v3_ar_and_en.csv"
)
 
app = FastAPI(title="Palestine Tourism Recommendation API")
 
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
 
# ---------------------------------------------------------------------------
# Arabic <-> English lookup for the categorical INPUT fields only.
# (These never appear in the output anymore — output is name/description/cost only)
# ---------------------------------------------------------------------------
CITY_AR_TO_EN = {
    "نابلس": "Nablus", "بيت لحم": "Bethlehem", "الخليل": "Hebron",
    "أريحا": "Jericho", "رام الله": "Ramallah", "القدس": "Jerusalem",
    "جنين": "Jenin", "طولكرم": "Tulkarm", "طوباس": "Tubas", "قلقيلية": "Qalqilya",
}
BUDGET_AR_TO_EN = {"منخفض": "Low", "متوسط": "Medium", "مرتفع": "High"}
TRIP_TYPE_AR_TO_EN = {
    "ديني": "Religious", "تراثي": "Cultural", "مغامرة": "Adventure",
    "عائلي": "Family", "استرخاء": "Relaxing", "تعليمي": "Educational",
}
AGE_GROUP_AR_TO_EN = {"عائلي": "Family", "شبابي": "Youth", "للجميع": "All"}
 
 
# ---------------------------------------------------------------------------
# Request schemas
# ---------------------------------------------------------------------------
class TripRequest(BaseModel):
    city: Literal[
        "Nablus", "Jerusalem", "Bethlehem", "Ramallah",
        "Jericho", "Hebron", "Jenin", "Tulkarm", "Tubas", "Qalqilya"
    ]
    budget_level: Literal["Low", "Medium", "High"]
    trip_type: Literal[
        "Religious", "Cultural", "Adventure", "Family", "Relaxing", "Educational"
    ]
    age_group: Literal["Youth", "Family", "All"]
    num_people: int = Field(ge=1, default=1)
    top_n: int = Field(ge=1, le=50, default=10)
 
 
class TripRequestAR(BaseModel):
    city_ar: str
    budget_level_ar: str
    trip_type_ar: str
    age_group_ar: str
    num_people: int = Field(ge=1, default=1)
    top_n: int = Field(ge=1, le=50, default=10)
 
 
@app.get("/")
def health_check():
    return {"status": "ok", "places_loaded": len(places_df)}
 
 
def _run_model(city, budget_level, trip_type, age_group, num_people, top_n):
    """Runs the model and returns the raw results DataFrame. Internal use only."""
    return get_recommendations(
        city=city,
        budget_level=budget_level,
        trip_type=trip_type,
        age_group=age_group,
        encoder=encoder,
        feature_matrix=feature_matrix,
        df=places_df,
        num_people=num_people,
        top_n=top_n,
        verbose=False,
    )
 
 
# ---------------------------------------------------------------------------
# English endpoint — returns ONLY name, description, cost. Nothing else.
# ---------------------------------------------------------------------------
@app.post("/recommend")
def recommend(req: TripRequest):
    try:
        results = _run_model(
            req.city, req.budget_level, req.trip_type,
            req.age_group, req.num_people, req.top_n
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
 
    records = []
    for row in results.to_dict(orient="records"):
        records.append({
            "name": row.get("Place_Name"),
            "description": row.get("Description"),
            "cost": f"{row.get('Total_Cost_ILS')} ILS",
        })
 
    return {"results": records}
 
 
# ---------------------------------------------------------------------------
# Arabic endpoint — returns ONLY name, description, cost. Nothing else.
# ---------------------------------------------------------------------------
@app.post("/recommend-ar")
def recommend_ar(req: TripRequestAR):
    city = CITY_AR_TO_EN.get(req.city_ar.strip())
    budget_level = BUDGET_AR_TO_EN.get(req.budget_level_ar.strip())
    trip_type = TRIP_TYPE_AR_TO_EN.get(req.trip_type_ar.strip())
    age_group = AGE_GROUP_AR_TO_EN.get(req.age_group_ar.strip())
 
    missing = [
        name for name, val in [
            ("city_ar", city), ("budget_level_ar", budget_level),
            ("trip_type_ar", trip_type), ("age_group_ar", age_group),
        ] if val is None
    ]
    if missing:
        raise HTTPException(
            status_code=422,
            detail=f"قيمة غير معروفة بالحقول التالية: {', '.join(missing)}"
        )
 
    try:
        results = _run_model(
            city, budget_level, trip_type, age_group,
            req.num_people, req.top_n
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
 
    records = []
    for row in results.to_dict(orient="records"):
        records.append({
            "الاسم": row.get("Place_Name_AR"),
            "الوصف": row.get("Description_AR"),
            "التكلفة": f"{row.get('Total_Cost_ILS')} شيكل",
        })
 
    return {"النتائج": records}
 