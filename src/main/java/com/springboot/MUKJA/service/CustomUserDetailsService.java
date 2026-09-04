package com.springboot.MUKJA.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.usersDTO;


@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private usersDAO dao;

    @Override
    public UserDetails loadUserByUsername(String u_id)
            throws UsernameNotFoundException {

        usersDTO dto = dao.findById(u_id);

        if (dto == null) {
            throw new UsernameNotFoundException("회원이 없습니다.");
        }

        return User.builder()
                .username(dto.getU_id())
                .password(dto.getU_passwd())
                .roles(dto.getU_auth())
                .disabled("NONE".equals(dto.getU_stats()))
                .build();
    }
}