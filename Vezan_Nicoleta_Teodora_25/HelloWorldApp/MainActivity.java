package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Button helloWorld = (Button) findViewById(R.id.button);

        final TextView helloText = (TextView) findViewById(R.id.helloId);
        helloText.setVisibility(View.INVISIBLE);

        helloWorld.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EditText nameBox = (EditText) findViewById(R.id.nameBox);
                if( !nameBox.getText().toString().isEmpty()) {
                    String name = nameBox.getText().toString();
                    helloText.setText("Hello, " + name + "! Welcome to my first application!");
                    helloText.setVisibility(View.VISIBLE);
                }else{
                    helloText.setText("Please insert your name!");
                    helloText.setVisibility(View.VISIBLE);
                }
            }
        });

    }
}
