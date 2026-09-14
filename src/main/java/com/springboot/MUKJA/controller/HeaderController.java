package com.springboot.MUKJA.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.springboot.MUKJA.dao.mukjaSearchDAO;

@ControllerAdvice
public class HeaderController {

    @Autowired
    private mukjaSearchDAO mukjaSearchdao;

    @ModelAttribute
    public void headerData(Model model) {

        model.addAttribute(
            "popularSearchList",
            mukjaSearchdao.popularSearchList()
        );
    }
}