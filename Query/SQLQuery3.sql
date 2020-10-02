USE RALaundry

--service simulation
INSERT INTO RaServiceTransaction VALUES ('SR001','ST004','CU002','CL001')
INSERT INTO RaServiceTransactionDetail VALUES('SR001', '2019/02/01', '50000', 'Dry Cleaning Service')

--purchase simulation
INSERT INTO RaTransactionMaterial VALUES ('PU001','ST002','MA003','VE001')
INSERT INTO RaTransactionMaterialDetail VALUES ('PU001', '2019/01/02', '50')