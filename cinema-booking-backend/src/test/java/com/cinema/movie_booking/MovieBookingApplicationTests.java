package com.cinema.movie_booking;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:cinema_test;MODE=MySQL;DB_CLOSE_DELAY=-1",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "JWT_SECRET=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
})
class MovieBookingApplicationTests {

	@Test
	void contextLoads() {
	}

}
