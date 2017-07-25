using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ninject;

namespace LessonProject.Controllers
{
    public class HomeController : Controller
    {
        //[Inject]
        public App_Start.NinjectWebCommon.IWeapon weapon { get; set; }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}