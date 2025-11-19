*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAPG_GATE_HANDLE................................*
DATA:  BEGIN OF STATUS_ZAPG_GATE_HANDLE              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAPG_GATE_HANDLE              .
CONTROLS: TCTRL_ZAPG_GATE_HANDLE
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZAPG_POINT......................................*
DATA:  BEGIN OF STATUS_ZAPG_POINT                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAPG_POINT                    .
CONTROLS: TCTRL_ZAPG_POINT
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZAPG_GATE_HANDLE              .
TABLES: *ZAPG_POINT                    .
TABLES: ZAPG_GATE_HANDLE               .
TABLES: ZAPG_POINT                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
