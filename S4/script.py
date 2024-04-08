import csv

# Open the CSV file and iterate through each row
with open('transactions.csv', 'r') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        transaction_id = row['id']
        product_ids = row['product_ids'].split(',')

        # Insert a record into transactions_products for each product ID
        for product_id in product_ids:
            # Perform the insertion
            print(f"INSERT INTO transactions_products (transaction_id, product_id) VALUES ('{transaction_id}', '{product_id.strip()}');")
