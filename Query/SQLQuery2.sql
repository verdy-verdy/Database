USE RALaundry

--NOMOR 1
SELECT
	c.CustomerId,
	CustomerName,
	[TotalServicePrice] = SUM(std.ServicePrice)
FROM RaCustomer c, RaServiceTransactionDetail std, RaServiceTransaction st
WHERE
	c.CustomerId = st.CustomerId AND
	std.STransactionId = st.STransactionId AND
	CustomerGender = 'Male' AND
	DATENAME(MONTH, ServiceDate) = 'July'
GROUP BY
	c.CustomerId, CustomerName
	

--NOMOR 2
SELECT
	StaffName ,
	[PurchaseDate] = ServiceDate,
	[Total] = COUNT(st.STransactionId)
FROM RaStaff s, RaServiceTransactionDetail std, RaServiceTransaction st
WHERE
	s.StaffId = st.StaffId AND
	st.STransactionId = std.STransactionId AND
	StaffName LIKE('%o%')
GROUP BY
	StaffName,ServiceDate
HAVING 
	COUNT(st.STransactionId) > 1
	

--NOMOR 3
SELECT
	VendorName,
	PurchaseDate = CONVERT(VARCHAR,tmd.VendorPurchaseDate, 107),
	TotalTransaction = COUNT(tm.MTransactionID),
	TotalPurchasePrice = SUM(QtyMaterial*m.MaterialPrice)
FROM RaVendor v, RaTransactionMaterialDetail tmd, RaTransactionMaterial tm, RaMaterial m
WHERE
	v.VendorId = tm.VendorId AND
	tmd.MTransactionId = tm.MTransactionId AND
	VendorName LIKE ('%PT. %') 
GROUP BY 
	VendorName, VendorPurchaseDate
HAVING CAST(DAY(tmd.VendorPurchaseDate) as INT)%2 = 1


--NOMOR 4
SELECT 
	StaffName,
	MaterialName,
	[TotalTransaction] = COUNT(tm.MTransactionId),
	[TotalQuantity] = CAST(SUM(CAST(tmd.QtyMaterial AS INT))AS VARCHAR) + ' pcs'
FROM
	RaStaff s, RaMaterial m, RaTransactionMaterial tm, RaTransactionMaterialDetail tmd
WHERE 
	s.StaffId = tm.StaffId AND
	tm.MTransactionId  = tmd.MTransactionId AND
	MONTH(tmd.VendorPurchaseDate) = 7
GROUP BY StaffName, MaterialName
HAVING SUM(CAST(tmd.QtyMaterial AS INT)) < 9


--NOMOR 5
SELECT
	MaterialId = REPLACE(tm.MaterialId, 'MA', 'Material'),
	MaterialName = UPPER(MaterialName),
	[PurchaseDate] = VendorPurchaseDate,
	QtyMaterial
FROM RaMaterial m, RaTransactionMaterial tm, RaTransactionMaterialDetail tmd,
	(
	SELECT [AvgQty] = AVG(QtyMaterial)
	FROM RaTransactionMaterialDetail
	) AS AverageQty
WHERE
	m.MaterialId = tm.MaterialId AND
	tm.MTransactionId = tmd.MTransactionId AND
	MaterialType = 'Supplies' AND
	QtyMaterial > AverageQty.AvgQty
GROUP BY tm.MaterialId, MaterialName, VendorPurchaseDate, QtyMaterial
ORDER BY MaterialId ASC

--NOMOR 6
SELECT
	StaffName,
	CustomerName,
	ServiceDate =  CONVERT(VARCHAR,ServiceDate, 106)
FROM RaStaff s, RaCustomer c, RaServiceTransaction st, RaServiceTransactionDetail std,
	(
	SELECT [AvgSalary] = AVG(StaffSalary)
	FROM RaStaff
	) AS AverageSalary
WHERE
	S.StaffId = st.StaffId AND
	c.CustomerId = st.CustomerId AND
	std.STransactionId = st.STransactionId AND
	StaffSalary > AverageSalary.AvgSalary AND
	StaffName NOT LIKE ('% %')
GROUP BY StaffName, CustomerName, ServiceDate

--NOMOR 7
SELECT
	ClothesName,
	[TotalTransaction] = CAST(COUNT(st.STransactionId) AS VARCHAR) + ' transaction',
	ServiceType = SUBSTRING(ServiceType, 1, CHARINDEX(' ', ServiceType + ' ')-1),
	ServicePrice
FROM RaClothes cl, RaServiceTransaction st, RaServiceTransactionDetail std,
	(
	SELECT [AvgPrice] = AVG(ServicePrice)
	FROM RaServiceTransactionDetail
	) AS AverageServicePrice
WHERE
	cl.ClothesId = st.ClothesId AND
	std.STransactionId = st.STransactionId AND
	ServicePrice < AverageServicePrice.AvgPrice AND
	ClothesType = 'Cotton'
GROUP BY ClothesName, ServiceType, ServicePrice

--NOMOR 8
SELECT
	[StaffFirstName] = SUBSTRING(StaffName, 1, CHARINDEX(' ', StaffName + ' ')-1),
	VendorName,
	VendorPhone = REPLACE(VendorPhone, '08', '+628'),
	[TotalTransaction] = COUNT(tm.MTransactionId)
FROM RaStaff s, RaVendor v, RaTransactionMaterial tm, RaTransactionMaterialDetail tmd,
	(
	SELECT [AvgQty] = AVG(QtyMaterial)
	FROM RaTransactionMaterialDetail
	) AS AverageQty
WHERE
	s.StaffId = tm.StaffId AND
	v.VendorId = tm.VendorId AND
	QtyMaterial > AverageQty.AvgQty AND
	StaffName LIKE ('% %')
GROUP BY StaffName, VendorName, VendorPhone

--NOMOR 9
CREATE VIEW ViewMaterialPurchase
AS
SELECT
	MaterialName,
	[Material Price] = 'Rp. ' + CAST(CAST(MaterialPrice AS NUMERIC(11,2))AS VARCHAR),
	[TotalTransaction] = COUNT(tmd.MTransactionId),
	[TotalPrice] = 'Rp. ' + CAST(CAST(SUM(QtyMaterial*MaterialPrice) AS NUMERIC(11,2))AS VARCHAR)
FROM RaMaterial m, RaTransactionMaterial tm, RaTransactionMaterialDetail tmd
WHERE
	m.MaterialId = tm.MaterialId AND
	tmd.MTransactionId = tm.MTransactionId AND
	MaterialType = 'Supplies'
GROUP BY MaterialName, MaterialPrice
HAVING COUNT(tmd.MTransactionId)  > 2

SELECT * FROM ViewMaterialPurchase


--NOMOR 10
CREATE VIEW ViewMaleCustomerTransaction
AS
SELECT
	CustomerName,
	ClothesName,
	[TotalTransaction] = COUNT(std.STransactionId),
	[TotalPrice] = SUM(ServicePrice)
FROM RaCustomer c, RaClothes cl, RaServiceTransaction st, RaServiceTransactionDetail std
WHERE
	c.CustomerId = st.CustomerId AND
	cl.ClothesId = st.ClothesId AND
	st.STransactionId = std.STransactionId AND
	CustomerGender = 'Male' AND
	ClothesType IN ('Wool', 'Linen')
GROUP BY CustomerName, ClothesName

SELECT * FROM ViewMaleCustomerTransaction