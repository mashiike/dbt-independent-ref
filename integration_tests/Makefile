
test-redshift:
	dbt deps
	dbt seed --target redshift
	dbt run --target redshift --full-refresh
	dbt test --target redshift

clean:
	dbt clean
