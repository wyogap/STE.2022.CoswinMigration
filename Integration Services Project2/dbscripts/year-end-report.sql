-- Stock Issue
SELECT 
	Line, Dept, Authority_Code, ITEMNUM, COSWIN_Item_Code, Item_Description
	, Group_Code, Group_Description
	, concat(Group_Code, CONCAT(' - ', Group_Description)) AS Group_Code_Description
	, Category_Code, Issue_Date, Issued_Qty
	, CASE WHEN Return_Date BETWEEN '2023-01-01' AND '2023-12-31' THEN Returned_Qty ELSE 0 END AS Returned_Qty
	, MRNUM, Coswin_Demand_No
	, CostCentre, CostCentre_Description, Requester, IssueUnit
	, Inventory_CurBal AS Free_Quantity
	, WONUM, Coswin_WOID, Remarks
FROM MAXIMO.STE_RPT_STOCK_ISSUE
WHERE Issue_Date BETWEEN '2023-01-01' AND '2023-12-31'
;

-- Stock Download (Credit)
SELECT 10000 + ROW_NUMBER() OVER (ORDER BY A.ISSUE_NUM) AS TRANSACTION_NO
	, A.ISSUE_DATE AS DOCUMENT_DATE
	, '2024-03-18' AS POSTING_DATE
	, A.ISSUE_NUM
	, A.COSWIN_ISSUE_NUM
	, CONCAT('SI : ', A.MRNUM) AS DOC_HEADER_TEXT
	, A.COSWIN_DEMAND_NO
	, '' AS ACCOUNT
	, 50 as DEBIT_CREDIT
	, A.ISSUE_VALUE AS amount
	--, TRUNCATE(A.ISSUE_VALUE,2) AS AMOUNT
	, 'PS' AS TAX_CODE
	, 'DTL' AS Company_Code
	, 'RNEL' AS Business_Area
	, A.COSTCENTRE
	, A.CURRENCYCODE
	, A.ITEMNUM
	, A.COSWIN_ITEM_CODE
FROM MAXIMO.STE_RPT_STOCK_ISSUE A
WHERE 1=1
	AND A.Issue_Value>=0.02
	AND Issue_Date BETWEEN '2024-03-11' AND '2024-03-16'
;

-- Invoice STK (Debit)
SELECT *
FROM (
	-- Invoice STK (Debit)
	SELECT 
		concat('R', A.FREE3) AS Transaction_ID
		, A.SAP_Vendor_Code AS Vendor_ID
		, a.Invoice_Date
		, a.FREE3 AS Reference
		, '' AS Amount_Local_Currency
		, a.Currency_Code
		, 0 AS Tax_Base_Amount
		, a.SAPGLCODE AS Account
		, 31 AS Debit_Credit
		, a.LINECOST AS Amount
		, a.GST_CODE AS Tax_Code
		, 'DTL' AS Company_Code
		, 'RNEL' AS Business_Area
		, a.CostCentre 
		, a.Item_Description
		, a.REMARKS
		, a.Supplier
		, a.Supplier_Code
		, a.COUNTRY
		, a.Local_Address
		, a.ITEMNUM
		, a.Coswin_Item_Code
	FROM MAXIMO.STE_RPT_INVOICE A
	WHERE A.STK_NS='STK' 
		AND A.glpostdate BETWEEN '2024-03-11' AND '2024-03-15';
	
	UNION ALL
	
	-- Invoice STK (TAX-Debit)
	SELECT 
		concat('R', A.FREE3) AS Transaction_ID
		, A.SAP_Vendor_Code AS Vendor_ID
		, a.Invoice_Date
		, a.FREE3 AS Reference
		, '' AS Amount_Local_Currency
		, a.Currency_Code
		, a.BaseTotalCost AS Tax_Base_Amount
		, a.SAPGLCODE AS Account
		, 31 AS Debit_Credit
		, a.Total_Tax1_Value AS Amount
		, a.GST_CODE AS Tax_Code
		, 'DTL' AS Company_Code
		, 'RNEL' AS Business_Area
		, a.CostCentre 
		, a.Item_Description
		, a.REMARKS
		, a.Supplier
		, a.Supplier_Code
		, a.COUNTRY
		, a.Local_Address
		, a.ITEMNUM
		, a.Coswin_Item_Code
	FROM MAXIMO.STE_RPT_INVOICE A
	WHERE A.STK_NS='STK' AND A.Tax1_Value>0 AND A.LINENUM=1 
		AND A.glpostdate BETWEEN '2024-03-11' AND '2024-03-15'
) A;
