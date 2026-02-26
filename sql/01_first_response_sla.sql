use dataengg_projdb;

-- Run this first to enable local loading
SET GLOBAL local_infile = 1;

CREATE TABLE agents (
    agent_id VARCHAR(10) PRIMARY KEY,
    team VARCHAR(50),
    shift VARCHAR(20),
    tenure_months INT
);

LOAD DATA LOCAL INFILE 'E:/Course and training/Data ENGG Proj 3/mnt/data/project1_service_desk/agents.csv'
INTO TABLE agents
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE sla_policies (
    sla_policy_id VARCHAR(10) PRIMARY KEY,
    priority VARCHAR(5),
    target_first_response_mins INT,
    target_resolution_mins INT
);

LOAD DATA LOCAL INFILE 'E:/Course and training/Data ENGG Proj 3/mnt/data/project1_service_desk/sla_policies.csv'
INTO TABLE sla_policies
FIELDS TERMINATED BY ',' 

IGNORE 1 ROWS;


CREATE TABLE tickets (
    ticket_id VARCHAR(10) PRIMARY KEY,
    created_at DATETIME,
    channel VARCHAR(20),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    priority VARCHAR(5),
    assigned_agent_id VARCHAR(10),
    first_response_at DATETIME,
    resolved_at DATETIME NULL,
    status VARCHAR(20),
    requester_type VARCHAR(20),
    sla_policy_id VARCHAR(10),
    first_response_mins INT,
    resolution_mins FLOAT NULL,
    sla_first_response_met TINYINT(1), -- MySQL stores booleans as 0/1
    sla_resolution_met TINYINT(1)
);

LOAD DATA LOCAL INFILE 'E:/Course and training/Data ENGG Proj 3/mnt/data/project1_service_desk/tickets.csv'
INTO TABLE tickets
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS
(ticket_id, @created_at, channel, category, subcategory, priority, assigned_agent_id, 
 @first_response_at, @resolved_at, status, requester_type, sla_policy_id, 
 first_response_mins, @resolution_mins, @sla_first_met, @sla_res_met)
SET 
    -- Transform created_at and first_response_at
    created_at = STR_TO_DATE(TRIM(@created_at), '%d-%m-%Y %H:%i'),
    first_response_at = STR_TO_DATE(TRIM(@first_response_at), '%d-%m-%Y %H:%i'),
    
    -- Handle potentially empty resolved_at
    resolved_at = CASE 
        WHEN TRIM(@resolved_at) = '' THEN NULL 
        ELSE STR_TO_DATE(TRIM(@resolved_at), '%d-%m-%Y %H:%i') 
    END,

    -- Standardize other fields as before
    resolution_mins = NULLIF(TRIM(@resolution_mins), ''),
    sla_first_response_met = IF(TRIM(UPPER(@sla_first_met)) = 'TRUE', 1, 0),
    sla_resolution_met = IF(TRIM(UPPER(@sla_res_met)) = 'TRUE', 1, 0);
