# Bicycle-Manufacturer-Analysis
## I. Introduction
The goal of the project is to analyze various aspects of sales, production, and purchasing data to uncover key trends and performance metrics. The project seeks to provide insights and actionable recommendations on:
- Provide a comprehensive understanding of sales trends and customer behaviours to inform business strategies.
- Optimize production by understanding stock patterns relative to sales.
- Evaluate purchasing performance and pending orders to improve supply chain efficiency.
## II. Explore Data
### Query 01: Calculate the Quantity of items, Sales value & Order quantity by each Subcategory in L12M
<img width="488" alt="Screenshot 2024-10-21 at 15 49 20" src="https://github.com/user-attachments/assets/350825de-7a34-4301-8237-6210e57a3829">

- **Result**
<img width="774" alt="Screenshot 2024-10-21 at 15 52 51" src="https://github.com/user-attachments/assets/5229f010-1d00-4eee-b74a-69c434233011">

### Query 2: Calculate % YoY growth rate by SubCategory & release the top 3 categories with the highest growth rate. Can use metric: quantity_item. Round results to 2 decimal
<img width="888" alt="Screenshot 2024-10-21 at 15 57 18" src="https://github.com/user-attachments/assets/b15c7837-6b26-4472-b866-e26758150dfa">

- **Result**
<img width="632" alt="Screenshot 2024-10-21 at 15 57 45" src="https://github.com/user-attachments/assets/f7bf9e60-5a5b-4b9c-9a74-b76c4976b576">

### Query 3: Ranking Top 3 TeritoryID with the biggest Order quantity every year. If there's TerritoryID with the same quantity in a year, do not skip the rank number
<img width="503" alt="Screenshot 2024-10-21 at 15 59 04" src="https://github.com/user-attachments/assets/1fb06e58-3094-45a7-af48-d35a32c94903">

- **Result**
<img width="524" alt="Screenshot 2024-10-21 at 15 59 24" src="https://github.com/user-attachments/assets/c9a1dfcc-6b9c-4d64-b9b1-fe9f7ad468f5">

### Query 4: Calculate the Total Discount Cost belonging to the Seasonal Discount for each SubCategory
<img width="878" alt="Screenshot 2024-10-21 at 16 01 17" src="https://github.com/user-attachments/assets/a6a8078a-0ba3-4e57-b594-1a211d763c9e">

- **Result**
<img width="479" alt="Screenshot 2024-10-21 at 16 01 41" src="https://github.com/user-attachments/assets/3f7b24c7-648e-4bc9-80d1-1aa1e73073fc">

### Query 5: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis)
<img width="490" alt="Screenshot 2024-10-21 at 16 03 15" src="https://github.com/user-attachments/assets/a004ca3d-def8-4a60-b06e-cc21614f502d">

- **Result**
<img width="336" alt="Screenshot 2024-10-21 at 16 03 43" src="https://github.com/user-attachments/assets/bd40df02-ecf4-45ed-b50f-932b6e1fca56">

### Query 6: Trend of Stock level & MoM diff % by all product in 2011. If the % growth rate is null then 0. Round to 1 decimal

<img width="474" alt="Screenshot 2024-10-21 at 16 04 55" src="https://github.com/user-attachments/assets/6154a1d1-7972-4b5b-ade6-4043308ebe1d">

- **Result**
<img width="615" alt="Screenshot 2024-10-21 at 16 05 17" src="https://github.com/user-attachments/assets/dd45b9b6-8342-4462-9124-012ffad1216e">

### Query 7: "Calculate the Ratio of Stock / Sales in 2011 by product name, by month. Order results by month desc, ratio desc. Round Ratio to 1 decimal mom YoY
<img width="397" alt="Screenshot 2024-10-21 at 16 21 41" src="https://github.com/user-attachments/assets/5475f13b-1b6f-4601-acd2-9e9c52ca563c">

- **Result**
<img width="704" alt="Screenshot 2024-10-21 at 16 22 10" src="https://github.com/user-attachments/assets/adc3a46a-b1d3-4e07-a6b7-bb04db89da43">

### Query 8: No of order and value at Pending status in 2014
<img width="419" alt="Screenshot 2024-10-21 at 16 23 13" src="https://github.com/user-attachments/assets/f690e6b2-8a2f-4e72-9726-322173bca9d6">

- **Result**
<img width="501" alt="Screenshot 2024-10-21 at 16 23 30" src="https://github.com/user-attachments/assets/ac77f8c4-388e-4eb8-a1fd-28be508416dd">

