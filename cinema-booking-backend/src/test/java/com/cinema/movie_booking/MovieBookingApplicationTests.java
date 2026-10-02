package com.cinema.movie_booking;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.options;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@AutoConfigureMockMvc
@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:cinema_test;MODE=MySQL;DB_CLOSE_DELAY=-1",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "CORS_ALLOWED_ORIGINS=http://localhost:3000,https://frontend.example.test",
        "JWT_SECRET=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
})
class MovieBookingApplicationTests {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void contextLoads() {
	}

	@Test
	void publicCatalogRemainsAvailable() throws Exception {
		mockMvc.perform(get("/api/movies").contextPath("/api")).andExpect(status().isOk());
		mockMvc.perform(get("/api/vouchers").contextPath("/api")).andExpect(status().isOk());
	}

	@Test
	void anonymousUserCannotAccessAdminActions() throws Exception {
		mockMvc.perform(get("/api/admin/bookings").contextPath("/api")).andExpect(status().isUnauthorized());
		mockMvc.perform(post("/api/rooms").contextPath("/api")).andExpect(status().isUnauthorized());
		mockMvc.perform(post("/api/bookings/1/confirm").contextPath("/api")).andExpect(status().isUnauthorized());
	}

	@Test
	void corsAllowsConfiguredOriginWithAuthorizationHeader() throws Exception {
		mockMvc.perform(options("/api/users/me").contextPath("/api")
				.header("Origin", "https://frontend.example.test")
				.header("Access-Control-Request-Method", "GET")
				.header("Access-Control-Request-Headers", "authorization"))
				.andExpect(status().isOk())
				.andExpect(header().string("Access-Control-Allow-Origin", "https://frontend.example.test"))
				.andExpect(header().doesNotExist("Access-Control-Allow-Credentials"));
	}

	@Test
	void corsRejectsUnknownOrigin() throws Exception {
		mockMvc.perform(options("/api/users/me").contextPath("/api")
				.header("Origin", "https://unknown.example.test")
				.header("Access-Control-Request-Method", "GET"))
				.andExpect(status().isForbidden());
	}

}
