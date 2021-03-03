import streamlit as st
import pandas as pd
import base64
import matplotlib.pyplot as plt
import plotly.express as px
import seaborn as sns
import numpy as np

hop_data = pd.read_csv('hops_final_clean.csv')


sorted_fnpi = sorted(hop_data.from_npi.unique())
selected_from_npi =st.sidebar.multiselect('filter by from npi',sorted_fnpi,default=1093741464)
npi_selected = hop_data[(hop_data.from_npi.isin(selected_from_npi))]


st.dataframe(npi_selected)
st.write(npi_selected.patient_count.describe(),npi_selected.transaction_count.describe())

fig = px.treemap(hop_data, path=['from_npi'], values='patient_count')
fig
