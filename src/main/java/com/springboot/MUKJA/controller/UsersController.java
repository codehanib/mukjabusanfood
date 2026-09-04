package com.springboot.MUKJA.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.MUKJA.dao.usersDAO;
import com.springboot.MUKJA.dto.usersDTO;
import com.springboot.MUKJA.dao.restaurantDAO;
import com.springboot.MUKJA.dto.restaurantDTO;
import com.springboot.MUKJA.service.EmailVerificationService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UsersController {

    @Autowired
    private usersDAO usersDAO;
    
    @Autowired
    private restaurantDAO restaurantdao;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private EmailVerificationService emailVerificationService;

    @GetMapping("/")
    public String index() {
        return "redirect:/login/login";
    }

    @PostMapping("/usersInsert")
    public String usersInsert(HttpServletRequest request, usersDTO dto, HttpSession session) {
        String u_id = request.getParameter("u_id");
        String u_name = request.getParameter("u_name");
        String u_tel = request.getParameter("u_tel");
        String u_tel2 = request.getParameter("u_tel2");
        String u_tel3 = request.getParameter("u_tel3");
        String u_addr = request.getParameter("u_addr");
        String u_addr2 = request.getParameter("u_addr2");
        String u_zipno = request.getParameter("u_zipno");
        String u_email = request.getParameter("u_email");
        String u_email2 = request.getParameter("u_email2");
        String u_passwd = request.getParameter("u_passwd");
        String emailVerifyToken = request.getParameter("emailVerifyToken");

        String fullEmail = u_email + "@" + u_email2;

        if (!emailVerificationService.isVerifiedByToken(fullEmail, emailVerifyToken)) {
            return "redirect:/login/writeForm?error=emailNotVerified";
        }
        
        if (usersDAO.findByEmail(fullEmail) != null) {
            return "redirect:/login/writeForm?error=emailDuplicate";
        }

        dto.setU_id(u_id);
        dto.setU_name(u_name);
        dto.setU_tel(u_tel + "-" + u_tel2 + "-" + u_tel3);
        dto.setU_addr(u_addr + "," + u_addr2);
        dto.setU_zipno(u_zipno);
        dto.setU_email(fullEmail);

        if (u_passwd != null && !u_passwd.isEmpty()) {
            dto.setU_passwd(passwordEncoder.encode(u_passwd));
        }

        usersDAO.usersInsert(dto);
        emailVerificationService.clearToken(emailVerifyToken);
        return "redirect:/login/login";
    }

    @RequestMapping("/jusoPopup")
    public String jusoPopup() {
        return "login/jusoPopup";
    }

    @RequestMapping("/main")
    public String main(Model model) {
//
//        int start = 0;
//        int pageSize = 20;
//
//        List<restaurantDTO> restaurantList =
//                restaurantdao.mainrestaurantList(start, pageSize);
//
//        model.addAttribute("restaurantList", restaurantList);
//
        return "main";
    }

    @GetMapping("/checkId")
    @ResponseBody
    public Map<String, Boolean> checkId(@RequestParam("u_id") String u_id) {
        usersDTO existing = usersDAO.findById(u_id);
        Map<String, Boolean> result = new HashMap<>();
        result.put("duplicate", existing != null);
        return result;
    }

    @RequestMapping("/users/userviewForm")
    public String usersviewForm(Authentication authentication, Model model) {
        String u_id = authentication.getName();
        usersDTO dto = usersDAO.findById(u_id);
        model.addAttribute("view", dto);
        return "users/usersviewForm";
    }

    @RequestMapping("/users/passwordCheckForm")
    public String passwordCheckForm(HttpServletRequest request, Model model) {
        String mode = request.getParameter("mode");
        model.addAttribute("mode", mode);
        return "users/passwordCheckForm";
    }

    @RequestMapping("/users/passwordCheck")
    public String passwordCheck(Authentication authentication, HttpServletRequest request, Model model) {
        String mode = request.getParameter("mode");
        String u_passwd = request.getParameter("u_passwd");

        String u_id = authentication.getName();
        usersDTO dto = usersDAO.findById(u_id);

        if (dto != null && passwordEncoder.matches(u_passwd, dto.getU_passwd())) {
            if ("update".equals(mode)) {
                model.addAttribute("updateForm", dto);
                return "users/usersupdateForm";
            } else if ("delete".equals(mode)) {
                int u_no = dto.getU_no();
                int deliveryCnt = usersDAO.delivery(u_no);
                int bookmarkCnt = usersDAO.bookmark(u_no);
                int inquiryCnt = usersDAO.mukja_inquiry(u_no);
                int reviewCnt = usersDAO.review(u_no);
                int reservationCnt = usersDAO.reservation(u_no);

                if (deliveryCnt == 0 && bookmarkCnt == 0 && inquiryCnt == 0 && reviewCnt == 0 && reservationCnt == 0) {
                    usersDAO.adminDelete(u_no);
                } else {
                    usersDAO.usersDelete(u_id);
                }
                return "redirect:/logout";
            } else if ("passwd".equals(mode)) {
                return "users/userspasswdForm";
            }
        }

        model.addAttribute("msg", "비밀번호가 틀렸습니다.");
        model.addAttribute("mode", mode);

        return "users/passwordCheckForm";
    }

    @PostMapping("/users/usersUpdate")
    public String usersUpdate(HttpServletRequest request) {
        String u_id = request.getParameter("u_id");
        String u_tel = request.getParameter("u_tel");
        String u_tel2 = request.getParameter("u_tel2");
        String u_tel3 = request.getParameter("u_tel3");
        String u_addr = request.getParameter("u_addr");
        String u_addr2 = request.getParameter("u_addr2");
        String u_zipno = request.getParameter("u_zipno");
        String u_email = request.getParameter("u_email");
        String u_email2 = request.getParameter("u_email2");

        usersDTO dto = new usersDTO();
        dto.setU_id(u_id);
        dto.setU_tel(u_tel + "-" + u_tel2 + "-" + u_tel3);
        dto.setU_addr(u_addr + "," + u_addr2);
        dto.setU_zipno(u_zipno);
        dto.setU_email(u_email + "@" + u_email2);

        usersDAO.usersUpdate(dto);
        return "redirect:/users/userviewForm";
    }

    @RequestMapping("/admin/usersList")
    public String usersList(Model model) {
        List<usersDTO> usersList = usersDAO.usersList();
        model.addAttribute("usersList", usersList);
        return "admin/usersList";
    }

    @GetMapping("/admin/usersView")
    public String usersView(@RequestParam("u_no") int u_no, Model model) {
        usersDTO dto = usersDAO.usersView(u_no);
        model.addAttribute("view", dto);
        return "admin/usersView";
    }

    @GetMapping("/admin/usersDelete")
    public String adminUsersDelete(@RequestParam("u_no") int u_no) {
        usersDAO.adminDelete(u_no);
        return "redirect:/admin/usersList";
    }

    @PostMapping("/users/userspasswd")
    public String userspasswd(Authentication authentication, HttpServletRequest request, Model model) {
        String u_id = authentication.getName();
        String u_passwd = request.getParameter("u_passwd");
        String u_passwd2 = request.getParameter("u_passwd2");

        if (!u_passwd.equals(u_passwd2)) {
            model.addAttribute("msg", "비밀번호가 일치하지 않습니다.");
            return "users/userspasswdForm";
        }
        usersDTO dto = new usersDTO();
        dto.setU_id(u_id);
        dto.setU_passwd(passwordEncoder.encode(u_passwd));
        usersDAO.userspasswd(dto);
        return "redirect:/users/userviewForm";
    }

    @PostMapping("/admin/usersAuthUpdate")
    public String usersAuthUpdate(HttpServletRequest request) {
        int u_no = Integer.parseInt(request.getParameter("u_no"));
        String u_auth = request.getParameter("u_auth");
        int r_no = Integer.parseInt(request.getParameter("r_no"));

        usersDTO dto = new usersDTO();
        dto.setU_no(u_no);
        dto.setU_auth(u_auth);
        dto.setR_no(r_no);
        usersDAO.usersAuthUpdate(dto);

        return "redirect:/admin/usersView?u_no=" + u_no;
    }
    @GetMapping("/login/findPasswordForm")
    public String findPasswordForm() {
        return "login/findPasswordForm";
    }

    @GetMapping("/login/resetPasswordForm")
    public String resetPasswordForm(@RequestParam("u_id") String u_id,
                                     @RequestParam("email") String email,
                                     @RequestParam("token") String token,
                                     Model model) {
        if (!emailVerificationService.isVerifiedByToken(email, token)) {
            return "redirect:/login/findPasswordForm?error=notVerified";
        }
        model.addAttribute("u_id", u_id);
        model.addAttribute("email", email);
        model.addAttribute("token", token);
        return "login/resetPasswordForm";
    }

    @PostMapping("/password/reset")
    public String resetPassword(@RequestParam("u_id") String u_id,
                                 @RequestParam("email") String email,
                                 @RequestParam("token") String token,
                                 @RequestParam("u_passwd") String u_passwd,
                                 @RequestParam("u_passwd2") String u_passwd2) {
        if (!emailVerificationService.isVerifiedByToken(email, token)) {
            return "redirect:/login/findPasswordForm?error=notVerified";
        }
        if (!u_passwd.equals(u_passwd2)) {
            return "redirect:/login/resetPasswordForm?u_id=" + u_id + "&email=" + email + "&token=" + token + "&error=mismatch";
        }

        usersDTO dto = new usersDTO();
        dto.setU_id(u_id);
        dto.setU_passwd(passwordEncoder.encode(u_passwd));
        usersDAO.userspasswd(dto);

        emailVerificationService.clearToken(token);
        return "redirect:/login/login?resetSuccess=true";
    }
}