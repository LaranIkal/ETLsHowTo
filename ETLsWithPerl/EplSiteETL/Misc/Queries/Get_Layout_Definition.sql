SELECT a.SSEKindOfRecord, a.Description, b.FieldSequence, b.FieldDescription, b.ValueType,
b.ConstantValue, b.QueryField, b.QueryField1ForXRef, b.QueryField2ForXRef,
b.xreftype, c.TransformationScriptName, b.TransformationScriptParameters,
b.ExportField, b.Catalog, b.FieldNumForValidation1,b.FieldNumForValidation2
FROM gdlsouthcampus_mf_kindofrecords_export a
, gdlsouthcampus_mf_export_layouts b
LEFT JOIN gdlsouthcampus_mf_transformationscripts c
ON c.TransformationScriptID = b.TransformationScriptID
WHERE a.SSEKindOfRecord =  b.SSEKindOfRecord
AND b.SourceSystemCode = 'BaaNV'
AND b.SSEKindOfRecord=400
ORDER BY a.SSEKindOfRecord, b.FieldSequence
