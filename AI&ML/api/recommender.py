"""
Copied directly from palestine_tourism_recommendation.ipynb.
Do not change the logic here without re-running the notebook to confirm
the encoder/feature_matrix still match.
"""

import numpy as np
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

TRIP_TYPE_TO_PLACE_TYPE = {
    'Religious':   'Religious',
    'Cultural':    'Historic Old City',
    'Adventure':   'Nature & Trails',
    'Family':      'Family/Recreational',
    'Relaxing':    'Nature & Trails',
    'Educational': 'Museum'
}


def get_recommendations(city, budget_level, trip_type, age_group,
                         encoder, feature_matrix, df,
                         num_people=1, top_n=10, verbose=False):
    """
    Recommend tourist places in Palestine based on user preferences.

    Parameters
    ----------
    city         : str   - Nablus, Jerusalem, Bethlehem, Ramallah, Jericho,
                            Hebron, Jenin, Tulkarm, Tubas, Qalqilya
    budget_level : str   - 'Low', 'Medium', or 'High'
    trip_type    : str   - 'Religious', 'Cultural', 'Adventure',
                            'Family', 'Relaxing', 'Educational'
    age_group    : str   - 'Youth', 'Family', or 'All'
    encoder      : the loaded OneHotEncoder (from tourism_encoder.pkl)
    feature_matrix : the loaded feature matrix (from feature_matrix.npy)
    df           : the full places DataFrame (loaded from the CSV)
    num_people   : int   - used only to scale estimated cost
    top_n        : int   - number of recommendations to return
    verbose      : bool  - print a summary header (keep False for API use)

    Returns
    -------
    pandas.DataFrame
    """
    place_type = TRIP_TYPE_TO_PLACE_TYPE.get(trip_type, 'Historic Old City')

    user_input = {
        'type':         place_type,
        'City':         city,
        'Budget_Level': budget_level,
        'Age_Group':    age_group,
        'Trip_Type':    trip_type
    }

    user_df = pd.DataFrame([user_input])
    user_vector = encoder.transform(user_df)

    similarities = cosine_similarity(user_vector, feature_matrix)[0]

    result_df = df.copy()
    result_df['Similarity_Score'] = np.round(similarities, 4)
    result_df['Total_Cost_ILS'] = result_df['Estimated_Cost_ILS'] * num_people

    output_cols = [
        'Place_Name', 'Place_Name_AR', 'type', 'City', 'Budget_Level',
        'Age_Group', 'Trip_Type', 'Description', 'Description_AR',
        'Estimated_Cost_ILS', 'Total_Cost_ILS', 'Similarity_Score',
        'Latitude', 'Longitude'
    ]
    # Only keep columns that actually exist in df, in case a column name
    # differs slightly between versions of the CSV.
    output_cols = [c for c in output_cols if c in result_df.columns]

    recommendations = (
        result_df
        .nlargest(top_n, 'Similarity_Score')
        [output_cols]
        .reset_index(drop=True)
    )
    recommendations.index += 1

    if verbose:
        print(f"City: {city} | Budget: {budget_level} | Trip: {trip_type} "
              f"| Age: {age_group} | People: {num_people}")
        print(f"Inferred place type: {place_type}")

    return recommendations
