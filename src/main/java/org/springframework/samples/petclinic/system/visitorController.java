package org.springframework.samples.petclinic.system;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
class visitorControllerer {

	@GetMapping("/visitor")
	@ResponseBody
	public String logVisit() {
		String logEntry = "Welcome visit: \n";
		try {
			Files.write(Paths.get("C:\\app\\uploads\\visits.log"), logEntry.getBytes(StandardCharsets.UTF_8),
					StandardOpenOption.APPEND, StandardOpenOption.CREATE);
			return "Visit logged successfully";
		}
		catch (IOException e) {
			e.printStackTrace();
			return "Error logging visit: " + e.getMessage();
		}
	}

}