TRUNCATE TABLE Accounts
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1','资产类','Asset group',NULL,0,0,'','1','1')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1001','现金','Cash on hand',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1002','银行存款','Cash in bank',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1009','其他货币资金','Other monetary fund',NULL,0,0,'1','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('100901','外埠存款','Deposit in other cities',NULL,0,0,'1009','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('100902','银行本票','Cashier''s cheque',NULL,0,0,'1009','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('100903','银行汇票','Bank draft',NULL,0,0,'1009','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('100904','信用卡','Credit card',NULL,0,0,'1009','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('100905','信用保证金','Deposit to creditor',NULL,0,0,'1009','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('100906','存出投资款','Cash in investing account',NULL,0,0,'1009','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1101','短期投资','Short-term investments',NULL,0,0,'1','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('110101','股票','Short-term stock investments',NULL,0,0,'1101','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('110102','债券','Short-term bond investments',NULL,0,0,'1101','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('110103','基金','Short-term fund investments',NULL,0,0,'1101','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('110110','其他','Other short-term investments',NULL,0,0,'1101','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1102','短期投资跌价准备','Provision for loss on decline in value of short-term investments',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1111','应收票据','Notes receivable',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1121','应收股利','Dividends receivable',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1131','应收账款','Accounts receivable',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1133','其他应收款','Other receivable',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1141','坏账准备','Provision for bad debts',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1151','预付账款','Advance to suppliers',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1161','应收补贴款','Subsidy receivable',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1201','物资采购','Materials purchased',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1211','原材料','Raw materials',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1221','包装物','Containers',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1231','低值易耗品','Low cost and short lived articles',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1232','材料成本差异','Cost variances of material',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1241','自制半成品','Semi-finished products',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1243','库存商品','Merchandise inventory',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1244','商品进销差价','Margin between selling and purchasing price on merchandise',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1251','委托加工物资','Material on consignment for further processing',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1261','委托代销商品','Goods on consignment- out',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1271','受托代销商品','Goods on consignment-in',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1281','存货跌价准备','Provision for impairment of inventories',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1291','分期收款发出商品','Goods on installment sales',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1301','待摊费用','Prepaid expense',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1401','长期股权投资','Long-term equity investments',NULL,0,0,'1','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('140101','股票投资','Long-term stock investments',NULL,0,0,'1401','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('140102','其他股权投资','Other long-term equity investments',NULL,0,0,'1401','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1402','长期债权投资','Long-term debt investments',NULL,0,0,'1','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('140201','债券投资','Long-term bond investments',NULL,0,0,'1402','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('140202','其他债权投资','Other long-term debt investments',NULL,0,0,'1402','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1421','长期投资减值准备','Provision for impairment of long-term investments',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1431','委托贷款','Entrusted loan',NULL,0,0,'1','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('143101','本金','Principal of entrusted loan',NULL,0,0,'1431','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('143102','利息','Interest of entrusted loan',NULL,0,0,'1431','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('143103','减值准备','Provision for impairment of entrusted loan',NULL,0,0,'1431','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1501','固定资产','Fixed assets-cost',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1502','累计折旧','Accumulated depreciation',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1505','固定资产减值准备','Provision for impairment of fixed assets',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1601','工程物资','Construction material',NULL,0,0,'1','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('160101','专用材料','Specific purpose materials',NULL,0,0,'1601','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('160102','专用设备','Specific purpose equipments',NULL,0,0,'1601','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('160103','预付大型设备款','Prepayments for major equipments',NULL,0,0,'1601','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('160104','为生产准备的工具及器具','Tools and instruments prepared for production',NULL,0,0,'1601','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1603','在建工程','Construction in process',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1605','在建工程减值准备','Provision for impairment of construction in process',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1701','固定资产清理','Disposal of fixed assets',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1801','无形资产','Intangible assets',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1815','未确认融资费用','Unrecognized financing charges',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1901','长期待摊费用','Long-term deferred expenses',NULL,0,0,'1','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('1911','待处理财产损溢','Profit & loss of assets pending disposal',NULL,0,0,'1','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('191101','待处理流动资产损溢','Profit & loss of current-assets pending disposal',NULL,0,0,'1911','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('191102','待处理固定资产损溢','Profit & loss of fixed assets pending disposal',NULL,0,0,'1911','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2','负债类','debt group',NULL,0,0,'','1','1')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2101','短期借款','Short-term loans',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2111','应付票据','Notes payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2121','应付账款','Accounts payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2131','预收账款','Advance from customers',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2141','代销商品款','Accounts of consigned goods',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2151','应付工资','Wages payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2153','应付福利费','Welfare payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2161','应付股利','Dividends payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2171','应交税金','Taxes payable',NULL,0,0,'2','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217101','应交增值税','Value added tax payable',NULL,0,0,'2171','1','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710101','进项税额','Input VAT',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710102','已交税金','Payment of VAT',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710103','转出未交增值税','Outgoing of unpaid VAT',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710104','减免税款','VAT relief',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710105','销项税额','Output VAT',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710106','出口退税','Refund of VAT for export',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710107','进项税额转出','Outgoing of input VAT',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710108','出口抵减内销产品应纳税额','Merchandise VAT from expert to domestic sale',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('21710109','转出多交增值税','Outgoing of over-paid VAT',NULL,0,0,'217101','0','4')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217102','未交增值税','Unpaid VAT',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217103','应交营业税','Business tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217104','应交消费税','Consumer tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217105','应交资源税','Tax on natural resources payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217106','应交所得税','Income tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217107','应交土地增值税','Land appreciation tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217108','应交城市维护建设税','Urban maintenance and construction tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217109','应交房产税','Real estate tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217110','应交土地使用税','Land use tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217111','应交车船使用税','Vehicle and vessel usage tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('217112','应交个人所得税','Personal income tax payable',NULL,0,0,'2171','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2176','其他应交款','Other fund payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2181','其他应付款','Other payables',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2191','预提费用','Accrued expenses',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2201','待转资产价值','Pending transfer value of assets',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2211','预计负债','Estimable liabilities',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2301','长期借款','Long-term loans',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2311','应付债券','Bonds payable',NULL,0,0,'2','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('231101','债券面值','Par value of bond',NULL,0,0,'2311','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('231102','债券溢价','Bond premium',NULL,0,0,'2311','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('231103','债券折价','Bond discount',NULL,0,0,'2311','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('231104','应计利息','Accrued bond interest',NULL,0,0,'2311','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2321','长期应付款','Long-term payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2331','专项应付款','Specific account payable',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('2341','递延税款','Deferred tax',NULL,0,0,'2','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('3','共同类','Common group',NULL,0,0,'','1','1')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('3101','实收资本(或股本）','Paid-in capital（or share capital)',NULL,0,0,'3','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('3103','已归还投资','Retired capital',NULL,0,0,'3','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('3111','资本公积','Capital reserve',NULL,0,0,'3','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('311101','资本（或股本）溢价','Capital (or share capital) premium',NULL,0,0,'3111','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('311102','接受捐赠非现金资产准备','Restricted capital reserve of non-cash assets donation received',NULL,0,0,'3111','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('311103','接受现金捐赠','Reserve of cash donation received',NULL,0,0,'3111','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('311104','股权投资准备','Restricted capital reserve of equity investments',NULL,0,0,'3111','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('311105','拨款转入','Government grants received',NULL,0,0,'3111','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('311106','外币资本折算差额','Foreign currency capital conversion difference',NULL,0,0,'3111','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('311107','其他资本公积','Other capital reserve',NULL,0,0,'3111','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('3121','盈余公积','Surplus reserve',NULL,0,0,'3','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('312101','法定盈余公积','Statutory surplus reserve',NULL,0,0,'3121','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('312102','任意盈余公积','Discretionary earning surplus',NULL,0,0,'3121','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('312103','法定公益金','Statutory public welfare fund',NULL,0,0,'3121','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('312104','储备基金','Reserve fund',NULL,0,0,'3121','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('312105','企业发展基金','Enterprise development fund',NULL,0,0,'3121','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('312106','利润归还投资','Profit return for investment',NULL,0,0,'3121','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('3131','本年利润','Profit & loss summary',NULL,0,0,'3','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('3141','利润分配','Distribution profit',NULL,0,0,'3','1','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314101','其他转入','Other adjustments',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314102','提取法定盈余公积金','Extract for statutory surplus reserve',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314103','提取法定公益金','Extract for statutory public welfare fund',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314104','提取储备基金','Extract for reserve fund',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314105','提取企业发展基金','Extract for enterprise development fund',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314106','提取职工奖励及福利基金','Extract for staff bonus and welfare fund',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314107','利润归还投资','Profit return of capital invested',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314108','应付优先股股利','Preference share dividend payable',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314109','提取任意盈余公积','Extract for discretionary earning surplus',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314110','应付普通股股利','Ordinary share dividend payable',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('314111','转作资本（或股本）的普通股股利','Ordinary share dividend transfer to',NULL,0,0,'3141','0','3')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('4','所有者权益类','Owner''s equity group',NULL,0,0,'','1','1')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('4001','实收资本','Paid-up capital',NULL,0,0,'4','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('4002','资本公积','Contributed surplus',NULL,0,0,'4','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('4101','盈余公积','Earned surplus',NULL,0,0,'4','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('4103','本年利润','Profit for the current year',NULL,0,0,'4','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('4104','利润分配','Allocation of profits',NULL,0,0,'4','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('4201','库存股','Treasury stock',NULL,0,0,'4','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('5','成本类',NULL,NULL,0,0,'','1','1')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('5001','生产成本','Production cost',NULL,0,0,'5','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('5101','制造费用','Cost of production',NULL,0,0,'5','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('5201','劳务成本','Service cost',NULL,0,0,'5','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('5301','研发支出','Research and development expenditures',NULL,0,0,'5','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6','损益类','Profit and loss group',NULL,0,0,'','1','1')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6001','主营业务收入main','main business income',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6011','利息收入','interest income financial sharing',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6051','其他业务收入','other business income',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6061','汇兑损益','exchange gain or loss exclusively for finance',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6101','公允价值变动损益','sound value flexible loss and profit',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6111','投资收益','income on investment',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6301','营业外收入','nonrevenue receipt',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6401','主营业务成本','main business cost',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6402','其他业务支出','other business expense',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6405','营业税金及附加','business tariff and annex',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6411','利息支出','interest expense financial sharing',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6601','销售费用','marketing cost',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6602','管理费用','managing cost',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6603','财务费用','financial cost',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6604','勘探费用','exploration expense',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6701','资产减值损失','loss from asset devaluation',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6711','营业外支出','nonoperating expense',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6801','所得税','income tax',NULL,0,0,'6','0','2')
INSERT INTO Accounts(AccountID,AccountName,EnglishName,Pycode,Debit,Credit,ParentNodeID,IsParentFlag,Level) VALUES ('6901','以前年度损益调整','prior year profit and loss adjustment',NULL,0,0,'6','0','2')
