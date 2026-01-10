SELECT a.FieldSequence, a.ValueType, a.ConstantValue, a.QueryField, a.QueryField1ForXRef
, a.QueryField2ForXRef, a.xreftype, a.TransformationScriptID, a.TransformationScriptParameters
, b.CatalogTableName, a.FieldDescription, a.FieldNumForValidation1, a.FieldNumForValidation2 
, b.Field1ForValidation, b.Field1Type, b.Field2ForValidation, b.Field2Type
FROM eplsite_etl_export_layouts a
LEFT JOIN eplsite_etl_catalogs b
ON b.TableID = a.Catalog
WHERE a.ETLSchemeCode = 'ETLSample' 
AND a.TransformationCode= '001' 
AND a.ExportField='Yes' 
ORDER BY a.FieldSequence

