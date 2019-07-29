create database horus
go

create schema horus;
go

-- ----------------------------------------------------------------------------
-- Table horus.Metric
-- ----------------------------------------------------------------------------
create table horus.Metric (
    MetricID  INT NOT NULL IDENTITY(1,1),
    Name SYSNAME NOT NULL
    , Description  nvarchar(2000) NULL
    , Frequency int not NULL
    , StartDate DATETIMEOFFSET NOT NULL
    , Enabled BIT NOT NULL
)
GO

EXEC sp_addextendedproperty 
    @name = 'MS_Description', @value = 'Contains all information needed to setup and schedule the collection of the metric.'
  , @Level0Type = 'SCHEMA', @Level0Name = 'horus'
  , @Level1Type = 'TABLE' , @Level1Name = 'Metric';
GO

ALTER TABLE horus.Metric 
    ADD CONSTRAINT PK_Metric 
        PRIMARY KEY CLUSTERED ( MetricID );
GO

ALTER TABLE horus.Metric
    ADD CONSTRAINT chk_metric_frequency 
        CHECK ( Frequency > 0 )
GO
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- Table horus.Query
-- ----------------------------------------------------------------------------
CREATE TABLE horus.Query(
    QueryID         INT            NOT NULL IDENTITY(1,1)
  , SelectStmt      NVARCHAR(MAX)  NOT NULL
  , ParseSuccessful BIT            NOT NULL
);
GO

EXEC sp_addextendedproperty 
    @name = 'MS_Description', @value = 'The collection query could be slightly different for each version of SQL Server'
  , @Level0Type = 'SCHEMA', @Level0Name = 'horus'
  , @Level1Type = 'TABLE' , @Level1Name = 'Query';
GO

ALTER TABLE horus.Query 
    ADD CONSTRAINT PK_Query 
        PRIMARY KEY CLUSTERED ( QueryID );
GO
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- Table horus.MetricQuery
-- ----------------------------------------------------------------------------
CREATE TABLE horus.MetricQuery(
    MetricID   INT     NOT NULL
  , QueryID    INT     NOT NULL
  , SQLVersion TINYINT NOT NULL
);
GO

ALTER TABLE horus.MetricQuery
    ADD CONSTRAINT PK_MetricQuery 
        PRIMARY KEY CLUSTERED ( MetricID, QueryID, SQLVersion )
GO

ALTER TABLE horus.MetricQuery
    ADD CONSTRAINT FK_MetricQuery_Metric
        FOREIGN KEY ( MetricID )
        REFERENCES horus.Metric ( MetricID )
GO

ALTER TABLE horus.MetricQuery
    ADD CONSTRAINT FK_MetricQuery_Query
        FOREIGN KEY ( QueryID )
        REFERENCES horus.Query ( QueryID )
GO

ALTER TABLE horus.MetricQuery
    ADD CONSTRAINT DF_MetricQuery_SQLVersion
        DEFAULT (CAST(SERVERPROPERTY('ProductMajorVersion') AS INT)) FOR SQLVersion
GO
-- ----------------------------------------------------------------------------

