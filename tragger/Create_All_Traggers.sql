 -- This is the main caller for each sql script  
SET NOCOUNT ON  
GO  

PRINT 'Start Create All Traggers Process'  

:r 0_CreateTable.sql

PRINT 'Finish Create Table' 

:r 1_tgr_TDM_COMP_insert.sql
:r 1_tgr_TDM_COMP_delete.sql
:r 1_tgr_TDM_COMP_update.sql
:r 1_tgr_TDM_COMPVALUES.sql

PRINT 'Finish TDM_COMP Process' 

:r 2_tgr_TDM_TOOL_insert.sql
:r 2_tgr_TDM_TOOL_delete.sql
:r 2_tgr_TDM_TOOL_update.sql
:r 2_tgr_TDM_TOOLVALUES.sql

PRINT 'Finish TDM_TOOL Process' 

:r 3_tgr_TDM_COMP_TOOL_insert.sql
:r 3_tgr_TDM_COMP_TOOL_delete.sql
:r 3_tgr_TDM_COMP_TOOL_update.sql

PRINT 'Finish TDM_COMP_TOOL Process' 

:r 4_tgr_TDM_technology_insert.sql
:r 4_tgr_TDM_technology_delete.sql
:r 4_tgr_TDM_technology_update.sql

PRINT 'Finish TDM_technology Process' 

:r 5_tgr_TDM_LIST_insert.sql
:r 5_tgr_TDM_LIST_delete.sql
:r 5_tgr_TDM_LIST_update.sql

PRINT 'Finish TDM_LIST Process' 

:r 6_tgr_TDM_TOOL_LIST_insert.sql
:r 6_tgr_TDM_TOOL_LIST_delete.sql
:r 6_tgr_TDM_TOOL_LIST_update.sql
  
PRINT 'Finish ALL Process'  

GO  