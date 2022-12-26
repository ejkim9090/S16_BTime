package kh.semi.s16.bt.controller.log;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kh.semi.s16.bt.model.MemberVo;
import kh.semi.s16.bt.service.MemberService;

/**
 * Servlet implementation class LoginDoController
 */
@WebServlet("/Login.do")
public class LoginDoController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginDoController() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json;charset=UTF-8");
		MemberService service = new MemberService();
		
		String id = request.getParameter("id");
		String pwd = request.getParameter("pwd");
		
		MemberVo m = service.login(id, pwd);
		if(m != null) {
			HttpSession session = request.getSession();
			session.setAttribute("member", m);
			String viewPage = "WEB-INF/view/index.jsp";
			request.getRequestDispatcher(viewPage).forward(request, response);
		}else {
			//TODO
		}
	}

}