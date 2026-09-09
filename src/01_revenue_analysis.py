import pandas as pd 
import matplotlib.pyplot as plt 
import numpy as np 
import duckdb 

# duckdb for importing tables 
con = duckdb.connect('/home/priyansh/Documents/d/ecommerce dashboard/db/main.duckdb')

df = con.sql("""
    SELECT product_category_name_english, total_revenue, customer_city
    FROM question_one
""").df()

# finding the top 10 cities and top 10 categories overall without the exact numbers  
top_cities = df.groupby('customer_city')['total_revenue'].sum().nlargest(10).index
top_categories = df.groupby('product_category_name_english')['total_revenue'].sum().nlargest(10).index 

# create a new df to only include the top 10 performers 
filtered_df = df[df['customer_city'].isin(top_cities) & df['product_category_name_english'].isin(top_categories)]

# created a pivot table to order data into a wide format from a long format for the stacked bar chart 
pivot_df = filtered_df.pivot_table(
    index='customer_city',
    columns='product_category_name_english',
    values='total_revenue',
    aggfunc='sum'
)

# plotting the chart 
pivot_df.plot(kind='bar', stacked=True, figsize=(12, 7), colormap='viridis')

plt.title('Top 10 Product Categories Revenue across Top 10 Cities', fontsize=16)
plt.xlabel('Customer City', fontsize=12)
plt.ylabel('Total Revenue (BRL)', fontsize=12)
plt.xticks(rotation=45, ha='right')
plt.legend(title='Product Category', bbox_to_anchor=(1.05,1), loc='upper left')
plt.tight_layout()

plt.savefig('/home/priyansh/Documents/d/ecommerce dashboard/figures/combined_revenue_geography.png', dpi=300)
print('Image saved to the given folder.')

