package kh.semi.s16.bt.controller.book;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kh.semi.s16.bt.model.service.ReviewService;
import kh.semi.s16.bt.model.vo.ReviewVo;

/**
 * Servlet implementation class ReviewInsertDoController
 */
@WebServlet("/ReviewInsert.ajax")
public class ReviewInsertAjaxController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewInsertAjaxController() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ReviewService service = new ReviewService();
		ReviewVo review = new ReviewVo();
		
		//int rev_num -> 자동으로 쌓이는거 아닌가? 그럼 ddl.dml에서 rnum같은거로 설정해줘야 하는거 아님????//TODO
		String isbn = request.getParameter("isbn");
		String rev_txt = request.getParameter("rev_txt");
		Date rev_date = null;
		int each_grade = Integer.parseInt(request.getParameter("each_grade"));
		String id = request.getParameter("id");
		
		String fmRev_date = request.getParameter("rev_date");
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
		try {
			rev_date = (Date)fm.parse(fmRev_date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		review.setIsbn(isbn);
		review.setRev_txt(rev_txt);
		review.setRev_date(rev_date);
		review.setEach_grade(each_grade);
		review.setId(id);
		
		int result = service.insert(review);
		if(result > 0) {
			response.sendRedirect(request.getContextPath()+"/detail");
		}else {
			//TODO
		}
	}

}