package de.baumato.adapter.persistence;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.sql.DataSource;

import org.flywaydb.core.Flyway;

@Startup
@Singleton
public class DbMigration {

	@Resource(lookup = "jdbc/timely")
	private DataSource dataSource;

	@PostConstruct
	public void migrate() {
		Flyway flyway = new Flyway();
		flyway.setDataSource(dataSource);
		flyway.migrate();
	}
}
