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


#dtype ={'NPI':'object'}
df = pd.read_csv('from_npi_hop_data.csv',dtype ={'NPI':'object'})

sorted_df = sorted(df.NPI.unique())
selected_from_npi =st.sidebar.multiselect('filter by from npi',sorted_df,default=['1093741464','1104202761'])
npi_selected = df[(df.NPI.isin(selected_from_npi))]


fig = px.scatter_mapbox(npi_selected, lat='latitude',lon='longitude', color="patient_count",
                     hover_name="mailing_address",
                       color_continuous_scale=px.colors.cyclical.IceFire, size_max=15, zoom=10,
                       mapbox_style="carto-positron")
fig



# st.write(npi_selected)

'''fig = px.scatter(npi_selected, x="patient_count", y="transaction_count", size="average_day_wait", color="NPI",
           hover_name="mailing_address", log_x=True, size_max=60)
fig'''

'''fig = px.scatter(npi_selected, x="patient_count", y="transaction_count",
           size="average_day_wait", color="NPI", hover_name="mailing_address", facet_col="NPI",
           log_x=True, size_max=45)

fig'''

'''fig = px.bar(npi_selected, x='patient_count', y='transaction_count',color="NPI")
fig'''

'''fig = px.scatter_3d(npi_selected, x='patient_count', y='transaction_count', z='std_day_wait',color='NPI',size='average_day_wait')

fig'''

'''fig = px.bar(npi_selected, x='patient_count', y='transaction_count')

fig'''