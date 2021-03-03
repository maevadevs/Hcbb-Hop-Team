import streamlit as st
import pandas as pd
import base64
import matplotlib.pyplot as plt
import plotly.express as px
import seaborn as sns
import numpy as np

npi_data = pd.read_csv('clean_npidf.csv')
df = npi_data.fillna('missing')
#df['business_name'] = df['business_name'].astype(float)

sorted_npi = sorted(df.business_name.unique())
selected_business =st.sidebar.multiselect('filter by business',sorted_npi,default='VANDERBILT UNIVERSITY MEDICAL CENTER')
business_select = df[df.business_name.isin(selected_business)]


st.dataframe(df)