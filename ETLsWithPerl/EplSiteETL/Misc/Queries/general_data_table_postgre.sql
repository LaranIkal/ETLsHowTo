-- Table: GENERAL_DATA

-- DROP TABLE GENERAL_DATA;

CREATE TABLE GENERAL_DATA
(
  kindofdata character varying(100),
   DataField1   character varying(100),
   DataField2   character varying(100),
   DataField3   character varying(100),
   DataField4   character varying(256),
   DataField5   character varying(256),
   DataField6   character varying(256),
   DataField7   character varying(256),
   DataField8   character varying(256),
   DataField9   character varying(256),
   DataField10   character varying(256),
   DataField11   character varying(256),
   DataField12   character varying(256),
   DataField13   character varying(256),
   DataField14   character varying(256),
   DataField15   character varying(256),
   DataField16   character varying(256),
   DataField17   character varying(256),
   DataField18   character varying(256),
   DataField19   character varying(256),
   DataField20   character varying(256),
   DataField21   character varying(256),
   DataField22   character varying(256),
   DataField23   character varying(256),
   DataField24   character varying(256),
   DataField25   character varying(256),
   DataField26   character varying(256),
   DataField27   character varying(256),
   DataField28   character varying(256),
   DataField29   character varying(256),
   DataField30   character varying(256),
   DataField31   character varying(256),
   DataField32   character varying(256),
   DataField33   character varying(256),
   DataField34   character varying(256),
   DataField35   character varying(256),
   DataField36   character varying(256),
   DataField37   character varying(256),
   DataField38   character varying(256),
   DataField39   character varying(256),
   DataField40   character varying(256),
   DataField41   character varying(256),
   DataField42   character varying(256),
   DataField43   character varying(256),
   DataField44   character varying(256),
   DataField45   character varying(256),
   DataField46   character varying(256),
   DataField47   character varying(256),
   DataField48   character varying(256),
   DataField49   character varying(256),
   DataField50   character varying(256),
   DataField51   character varying(256),
   DataField52   character varying(256),
   DataField53   character varying(256),
   DataField54   character varying(256),
   DataField55   character varying(256),
   DataField56   character varying(256),
   DataField57   character varying(256),
   DataField58   character varying(256),
   DataField59   character varying(256),
   DataField60   character varying(256),
   DataField61   character varying(256),
   DataField62   character varying(256),
   DataField63   character varying(256),
   DataField64   character varying(256),
   DataField65   character varying(256),
   DataField66   character varying(256),
   DataField67   character varying(256),
   DataField68   character varying(256),
   DataField69   character varying(256),
   DataField70   character varying(256),
   DataField71   character varying(256),
   DataField72   character varying(256),
   DataField73   character varying(256),
   DataField74   character varying(256),
   DataField75   character varying(256),
   DataField76   character varying(256),
   DataField77   character varying(256),
   DataField78   character varying(256),
   DataField79   character varying(256),
   DataField80   character varying(256),
   DataField81   character varying(256),
   DataField82   character varying(256),
   DataField83   character varying(256),
   DataField84   character varying(256),
   DataField85   character varying(256),
   DataField86   character varying(256),
   DataField87   character varying(256),
   DataField88   character varying(256),
   DataField89   character varying(256),
   DataField90   character varying(256),
   DataField91   character varying(256),
   DataField92   character varying(256),
   DataField93   character varying(256),
   DataField94   character varying(256),
   DataField95   character varying(256),
   DataField96   character varying(256),
   DataField97   character varying(256),
   DataField98   character varying(256),
   DataField99   character varying(256),
   DataField100   character varying(256)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE GENERAL_DATA
  OWNER TO postgres;

-- Index: general_data_idx1

-- DROP INDEX general_data_idx1;

CREATE INDEX general_data_idx1
  ON GENERAL_DATA
  USING btree
  (kindofdata, DataField1, DataField2, DataField6);

-- Index: general_data_idx2

-- DROP INDEX general_data_idx2;

CREATE INDEX general_data_idx2
  ON GENERAL_DATA
  USING btree
  (kindofdata, DataField2, DataField5);

-- Index: general_data_idx3

-- DROP INDEX general_data_idx3;

CREATE INDEX general_data_idx3
  ON GENERAL_DATA
  USING btree
  (kindofdata, DataField1, DataField3);

-- Index: general_data_idx4

-- DROP INDEX general_data_idx4;

CREATE INDEX general_data_idx4
  ON GENERAL_DATA
  USING btree
  (kindofdata, DataField8);

-- Index: general_data_idx5

-- DROP INDEX general_data_idx5;

CREATE INDEX general_data_idx5
  ON GENERAL_DATA
  USING btree
  (kindofdata, DataField6);

