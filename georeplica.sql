-- Get geo-replication link status for all secondary databases (Query 55) (Geo-Replication Link Status)
SELECT link_guid, partner_server, partner_database, last_replication, 
       replication_lag_sec, replication_state_desc, role_desc, secondary_allow_connections_desc 
FROM sys.dm_geo_replication_link_status WITH (NOLOCK) OPTION (RECOMPILE);
------  

-- sys.dm_geo_replication_link_status (Azure SQL Database)
-- https://bit.ly/2GwIqC2