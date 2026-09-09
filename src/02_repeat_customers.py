import pandas as pd 
import matplotlib.pyplot as plt 
import numpy as np 
import duckdb 

# duckdb for importing tables 
con = duckdb.connect('/home/priyansh/Documents/d/ecommerce dashboard/db/main.duckdb')

df = con.sql("""
    SELECT customer_type, total_revenue 
    FROM question_two 
""").df()

plt.figure(figsize=(8,8))

plt.pie(
    df['total_revenue'],
    labels=df['customer_type'],
    autopct='%1.1f%%',
    startangle=90,
    colors=['#66b3ff','#ff9999']
)

plt.title('Revenue Breadown: Repeat vs. One-time Customers', fontsize=16)
plt.tight_layout()

plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/revenue_by_customer_type.png', dpi=300)
print('Image saved to the given folder.')
