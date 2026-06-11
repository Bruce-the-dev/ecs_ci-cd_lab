package com.amalitech.helloapp.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/hello")
public class HelloController {

    @GetMapping
    public ResponseEntity<String> hello() {
        return ResponseEntity.ok("Hello Get World");
    }
    @PostMapping
    public ResponseEntity<String> post() {
        return ResponseEntity.ok("Hello Post World ");
    }
}
