package de.baumato.ping.boundary;

import java.time.LocalDateTime;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

/**
 * PingResource returns the current date and time for the docker health check.
 */
@Path("ping")
public class PingResource {

  @GET
  public String ping() {
    return LocalDateTime.now().toString();
  }
}
