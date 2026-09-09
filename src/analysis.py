import pandas as pd 
import matplotlib.pyplot as plt 
import numpy as np 
import duckdb 

con = duckdb.connect('/home/priyansh/Documents/d/ecommerce dashboard/db/main.duckdb')

df = con.sql("""
    SELECT product_category_name_english, total_revenue, customer_city
    FROM question_one
""").df()

# 3. Aggregate the data for plotting
# (Summing revenue by category and grabbing the Top 10)
top_categories = df.groupby('product_category_name_english')['total_revenue'].sum().nlargest(10)

# 4. Create the visualization
plt.figure(figsize=(12, 6))
top_categories.plot(kind='bar', color='steelblue')

# 5. Format the chart to make it presentation-ready
plt.title('Top 10 Product Categories by Revenue', fontsize=16)
plt.xlabel('Product Category', fontsize=12)
plt.ylabel('Total Revenue (BRL)', fontsize=12)
plt.xticks(rotation=45, ha='right') # Tilts the labels so they don't overlap
plt.tight_layout() # Ensures nothing gets cut off

# Show the plot!
plt.savefig('top_10_categories.png', dpi=300)
print("Chart saved as top_10_categories.png")