# Palestine Tourism Recommendation System

## Overview

A content-based recommendation model that suggests Palestinian tourist places to a user based on their personal preferences, rather than returning the same generic list of attractions to everyone. The system is implemented as a Jupyter/Colab notebook that loads the tourism dataset, builds a feature representation of each place, and ranks places against a user's stated preferences using cosine similarity.

## Problem

Generic tourist lists ("Top 10 places in Palestine") don't account for who is actually traveling. A young adventure traveler on a tight budget and a family looking for a relaxed cultural weekend need very different recommendations, even if they're visiting the same region. This project addresses that by turning user preferences into a structured profile and matching it against each place's attributes, rather than presenting a static, one-size-fits-all list.

## Solution

The system generates personalized recommendations from five user-provided inputs:

- **City** (one or more)
- **Age Group**
- **Trip Type**
- **Total Budget**
- **Number of People**

These inputs are combined into a user profile vector and compared against every place in the dataset to produce a ranked, personalized set of recommendations.

## Recommendation Approach

```
User Input
   → Input Translation
   → User Profile
   → One-Hot Encoding
   → Cosine Similarity
   → Recommendation Score
   → Filtering
   → MMR (Maximal Marginal Relevance)
   → Top-N Recommendations
```

- **OneHotEncoder** – Converts categorical attributes (`type`, `City`, `Budget_Level`, `Age_Group`, `Trip_Type`) into binary feature columns so they can be compared numerically.
- **Cosine Similarity** – Measures how closely a user's preference vector aligns with each place's feature vector; a higher score means a stronger match.
- **Recommendation Score** – Combines the cosine similarity with direct match signals (city match, trip type match, age match) and a budget fit component into a single weighted score.
- **Budget Fit** – Compares each place's estimated cost (scaled by number of people) against the user's total budget, favoring places that comfortably fit within it.
- **MMR (Maximal Marginal Relevance)** – Re-ranks the top candidates to balance relevance with diversity, so the final list isn't dominated by near-duplicate places (e.g. ten similar ruins in the same city).

## Dataset

- **File:** `palestine_tourist_attractions_v2.csv`
- **Size (after cleaning):** 308 places × 17 columns
- **Columns:** `ID`, `Place_Name`, `type`, `City`, `Budget_Level`, `Age_Group`, `Trip_Type`, `Description`, `Latitude`, `Longitude`, `Coordinate_Source`, `Geocode_Status`, `Estimated_Cost_ILS`, `Place_Name_AR`, `Description_AR`, `Description_EN`, `Image_URL`
- **Features used for modeling:** `type`, `City`, `Budget_Level`, `Age_Group`, `Trip_Type`

## Project Structure

| File | Purpose |
|------|---------|
| `palestine_tourism_recommendation.ipynb` | Main notebook: data loading, feature engineering, model building, testing, and evaluation |
| `palestine_tourist_attractions_v2.csv` | Source dataset of tourist places |
| `tourism_data.pkl` | Exported tourism dataset (for backend use) |
| `encoder.pkl` | Fitted `OneHotEncoder` used to transform new user input |
| `feature_matrix.pkl` | Pre-computed one-hot feature matrix for all places |

## Input

The recommendation function accepts the following user inputs:

| Input | Type | Description |
|-------|------|-------------|
| `cities` | list of strings | One or more target cities (translated from Arabic via `CITY_MAP`) |
| `ages` | list of strings | Age group(s), e.g. `Youth`, `Family`, `All` (translated via `AGE_MAP`) |
| `trip_types` | list of strings | Desired trip type(s), e.g. `Adventure`, `Cultural`, `Religious` (translated via `TRIP_TYPE_MAP`) |
| `total_budget` | number | Total budget in ILS for the trip |
| `people_over_10` | number | Number of people the budget is split across |
| `top_n` | number | Number of recommendations to return (default 10) |

Raw user input may be provided in Arabic; `translate_user_input()` maps city, trip type, and age values to their English equivalents before they're used to build the user profile.

## Output

The system returns a ranked table of recommended places with their similarity/recommendation scores. Example output columns:

```
Place_Name_AR | City   | Budget_Level | Age_Group | Trip_Type | Estimated_Cost_ILS | Total_Cost_ILS | Similarity_Score
جبل جرزيم والطائفة السامرية | Nablus | Low    | Youth | Adventure | 5  | 15  | 0.833062
برج الفارعة                 | Tubas  | Medium | All   | Cultural  | 60 | 180 | 0.693546
```

`Similarity_Score` reflects how well a place matches the user's combined preferences (feature similarity, city/trip/age match, and budget fit). A score of `1.0` indicates maximum similarity between the encoded vectors, not a guaranteed exact match on every criterion.

## Technologies

- Python
- pandas, NumPy
- scikit-learn (`OneHotEncoder`, `cosine_similarity`)
- matplotlib, seaborn (visualization)
- joblib (model/artifact export)
- Jupyter Notebook / Google Colab

## Limitations

- The dataset covers 308 verified places, which may not represent every attraction across all Palestinian cities.
- As a content-based system, recommendations rely entirely on the tags/attributes present in the dataset (`type`, `City`, `Budget_Level`, `Age_Group`, `Trip_Type`); it has no user history or ratings to learn from.
- It cannot capture nuanced preferences that aren't reflected in the categorical fields, since it doesn't yet use free-text fields like `Description`.

## Future Improvements

> The following are proposed directions, not implemented functionality.

- Add TF-IDF or embedding-based similarity on the `Description` field to capture richer semantic meaning.
- Incorporate user feedback/ratings to enable collaborative filtering.
- Combine content-based features with behavioral or semantic signals in a hybrid model.
- Expand the dataset with more verified places to improve recommendation diversity.

## Author / Team

AI Travel Squad — AI Track Contribution
