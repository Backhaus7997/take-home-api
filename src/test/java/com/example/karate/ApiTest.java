// src/test/java/com/example/karate/ApiTest.java
package com.example.karate;

import com.intuit.karate.junit5.Karate;

class ApiTest {
    @Karate.Test
    Karate runAll() {
        // Runs everything under src/test/resources/features
        return Karate.run("classpath:features");
    }
}