import streamlit as st
import pandas as pd
import base64
import matplotlib.pyplot as plt
import plotly.express as px
import seaborn as sns
import numpy as np
import pydeck as pdk
import pandas_profiling as pp
import plotly.graph_objects as go

hosp_df = pd.read_csv('nashville_hospitals_normalized.csv',dtype ={'to_npi':'object'})
ref_df = pd.read_csv('nashville_referrals_normalised.csv')

ref_df = ref_df.dropna(axis=0,how ='any')

sorted_hospital = sorted(hosp_df.to_facility_name_normalised.unique())
selected_from_hospital =st.sidebar.multiselect('filter from hospital',sorted_hospital,default=['TriStar Skyline Medical Center HCA','TriStar Horizon Medical Center HCA'])
name_selected = hosp_df[(hosp_df.to_facility_name_normalised.isin(selected_from_hospital))]


sorted_npi = sorted(ref_df.to_npi.unique())
selected_from_npi =st.sidebar.multiselect('filter by to_npi',sorted_npi,default=[1295780476,1871530832])
npi_selected = ref_df[(ref_df.to_npi.isin(selected_from_npi))]

sorted_specialty = sorted(ref_df.from_npi_specialty.unique())
selected_from_specialty =st.sidebar.multiselect('filter by specialty',sorted_specialty,default=['Nurse Practitioner','Internal Medicine'])
specialty_selected = ref_df[(ref_df.from_npi_specialty.isin(selected_from_specialty))]

sorted_tonpi = sorted(ref_df.from_npi.unique())
selected_to_npi =st.sidebar.multiselect('filter by from_npi',sorted_tonpi,default=1417131715)
from_npi_selected = ref_df[(ref_df.from_npi.isin(selected_to_npi))]

#st.dataframe(specialty_selected)
st.dataframe(name_selected)

fig = px.treemap(npi_selected, path=['from_npi_specialty'], values='patient_count',color='transaction_count',
color_continuous_scale='RdBu')
fig



afig = px.bar(specialty_selected, x='from_npi_specialty', y='transaction_count',
             hover_data=['from_npi', 'to_npi'], color='patient_count',
              height=400)
afig


bfig = px.bar(from_npi_selected, x='to_facility_name_normalised', y='patient_count',
             hover_data=['average_day_wait', 'to_facility'], color='transaction_count',
              height=400)
bfig