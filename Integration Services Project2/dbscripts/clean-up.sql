delete from maximo.asset WHERE ste_migrationid is null;
delete from maximo.plustassetalias WHERE ste_migrationid is null;
delete from maximo.PLUSTASSETSTHIST WHERE ste_migrationid is null;
delete from maximo.assetlocusercust WHERE ste_migrationid is null;
delete from maximo.ste_cswnassetslhist WHERE ste_migrationid is null;
delete from maximo.assettrans WHERE ste_migrationid is null;
delete from maximo.assetspec WHERE ste_migrationid is null;
delete from maximo.sparepart WHERE ste_migrationid is null;
delete from maximo.route_stop WHERE ste_migrationid is null;
delete from maximo.assetancestor WHERE ste_migrationid is null;
delete from maximo.tloamassetgrp WHERE ste_migrationid is null;
delete from maximo.assetmeter WHERE ste_migrationid is null;
delete from maximo.meterreading WHERE ste_migrationid is null;
delete from maximo.PLUSTMTRCHNG WHERE ste_migrationid is null;

delete from maximo.inventory WHERE ste_migrationid is null;
delete from maximo.invvendor WHERE ste_migrationid is null;
delete from maximo.invbalances WHERE ste_migrationid is null;
delete from maximo.invlot WHERE ste_migrationid is null;
delete from maximo.invcost WHERE ste_migrationid is null;
delete from maximo.mr WHERE ste_migrationid is null;
delete from maximo.mrline WHERE ste_migrationid is null;
delete from maximo.invtrans WHERE ste_migrationid is null;

DELETE FROM MAXIMO.MATUSETRANS WHERE ste_migrationid is null;
DELETE FROM MAXIMO.INVUSE WHERE ste_migrationid is null;
DELETE FROM MAXIMO.INVUSELINE WHERE ste_migrationid is null;
DELETE FROM MAXIMO.INVRESERVE WHERE ste_migrationid is null;

delete from maximo.contract WHERE ste_migrationid is null;
delete from maximo.contractline WHERE ste_migrationid is null;
delete from maximo.contractauth WHERE ste_migrationid is null;
delete from maximo.pr WHERE ste_migrationid is null;
delete from maximo.prline WHERE ste_migrationid is null;
delete from maximo.prcost WHERE ste_migrationid is null;
delete from maximo.rfq WHERE ste_migrationid is null;
delete from maximo.rfqline WHERE ste_migrationid is null;
delete from maximo.rfqvendor WHERE ste_migrationid is null;
delete from maximo.quotationline WHERE ste_migrationid is null;
delete from maximo.po WHERE ste_migrationid is null;
delete from maximo.poline WHERE ste_migrationid is null;
delete from maximo.pocost WHERE ste_migrationid is null;
delete from maximo.invoice WHERE ste_migrationid is null;
delete from maximo.invoiceline WHERE ste_migrationid is null;
delete from maximo.invoicecost WHERE ste_migrationid is null;
delete from maximo.matrectrans WHERE ste_migrationid is null;
delete from maximo.servrectrans WHERE ste_migrationid is null;
delete from maximo.contractpurch WHERE ste_migrationid is null;
delete from maximo.ste_cswnreceipt_per_cc;

delete from maximo.workorder WHERE ste_migrationid is null;
delete from maximo.labtrans WHERE ste_migrationid is null;
delete from maximo.ticket WHERE ste_migrationid is null;
delete from maximo.tkserviceaddress WHERE ste_migrationid is null;
delete from maximo.failurereport WHERE ste_migrationid is null;
delete from maximo.ste_altfailurecode WHERE ste_migrationid is null;
delete from maximo.relatedrecord WHERE ste_migrationid is null;
delete from maximo.wplabor WHERE ste_migrationid is null;
delete from maximo.wpmaterial WHERE ste_migrationid is null;
delete from maximo.multiassetlocci WHERE ste_migrationid is null;

DELETE FROM MAXIMO.PLUSTWOQUALFLG WHERE ste_migrationid is null;
DELETE FROM MAXIMO.WOANCESTOR WHERE ste_migrationid is null;
DELETE FROM MAXIMO.WOSERVICEADDRESS WHERE ste_migrationid is null;
DELETE FROM MAXIMO.WOSTATUS WHERE ste_migrationid is null;
DELETE FROM MAXIMO.WORKVIEW WHERE ste_migrationid is null;

DELETE FROM MAXIMO.ITEM WHERE ste_migrationid is null;
DELETE FROM MAXIMO.ITEMORGINFO WHERE ste_migrationid is null;
DELETE FROM MAXIMO.ALTITEM WHERE ste_migrationid is null;
DELETE FROM MAXIMO.SERVICEITEMS WHERE ste_migrationid is null;
DELETE FROM MAXIMO.STE_ITEM_MAINTENTITY WHERE ste_migrationid is null;

DELETE FROM MAXIMO.ROUTES WHERE ste_migrationid is null;
DELETE FROM MAXIMO.ROUTE_STOP WHERE ste_migrationid is null;

DELETE FROM MAXIMO.LOCATIONS WHERE ste_migrationid is null;
DELETE FROM MAXIMO.LOCSTATUS WHERE ste_migrationid is null;
DELETE FROM MAXIMO.LOCOPER WHERE ste_migrationid is null;
DELETE FROM MAXIMO.LOCANCESTOR WHERE ste_migrationid is null;
DELETE FROM MAXIMO.LOCHIERARCHY WHERE ste_migrationid is null;

DELETE FROM MAXIMO.JOBPLAN WHERE ste_migrationid is null;
DELETE FROM MAXIMO.JPASSETSPLINK WHERE ste_migrationid is null;
DELETE FROM MAXIMO.JOBTASK WHERE ste_migrationid is null;
DELETE FROM MAXIMO.JOBLABOR WHERE ste_migrationid is null;
DELETE FROM MAXIMO.JOBITEM WHERE ste_migrationid is null;
DELETE FROM MAXIMO.PM WHERE ste_migrationid is null;
DELETE FROM MAXIMO.PMMETER WHERE ste_migrationid is null;
DELETE FROM MAXIMO.PMSEASONS WHERE ste_migrationid is null;

--DELETE FROM MAXIMO.SKDACTION WHERE ste_migrationid is null;
--DELETE FROM maximo.SKDPROJECT WHERE ste_migrationid is null;
--DELETE FROM maximo.SKDQUERY WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDACTIVITY WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDPROJECTSTATUS WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDSTATE WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDPROJECTSHIFTS WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDUSAGE WHERE ste_migrationid is null;
-- MOSTLY EMPTY TABLES
--DELETE FROM MAXIMO.SKDCOMPLIANCE WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDCOMPLIANCEWOLIST WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDCONSTRAINT WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDCOST WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDCOSTTEMP WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDEMAVAILRES WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDEXTRACAPACITY WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDEXTRACAPCRAFTVIEW WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDEXTRACAPCREWVIEW WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDEXTRACAPTOOLVIEW WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDLABORHRS WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDLABORHRSTEMP WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDODMEMSG WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDODMERUN WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDOPTPARAM WHERE SKDPROJECTID IS NOT NULL WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDPMFOCOST WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDPMFOCOSTTEMP WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDPMFORECAST WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDPMFORECASTJP WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDRESERVATION WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDRESOURCE WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDRESOURCEUSE WHERE ste_migrationid is null;
--DELETE FROM MAXIMO.SKDWORKPLANEXTCAP WHERE ste_migrationid is null;

DELETE FROM MIGRATION.STE_MIGRATION_LOGS;
DELETE FROM MIGRATION.STE_MIGRATION_LOG_DETAILS;
DELETE FROM MIGRATION.STE_MIGRATION_DEBUG_LOG;

--DROP TABLE MIGRATION.STE_MAXDOMAIN_VALIDATION_LOG_20250121;
--DROP TABLE MIGRATION.STE_MIGRATION_LOGS_OLD;
