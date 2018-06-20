CREATE SEQUENCE timely.s_event_id START WITH 1;
 
CREATE TABLE timely.event (
  id INT NOT NULL,
  kind VARCHAR(50) NOT NULL,
  last_change DATE,
 
  CONSTRAINT pk_event PRIMARY KEY (ID)
);