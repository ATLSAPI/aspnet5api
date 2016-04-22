using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using aspnet5api.Services;
using Microsoft.AspNet.Mvc;

// For more information on enabling Web API for empty projects, visit http://go.microsoft.com/fwlink/?LinkID=397860

namespace aspnet5api.Controllers
{
    [Route("api/[controller]")]
    public class TodosController : Controller
    {
        [FromServices]
        public ITodoService TodoService { get; set; }

        // GET: api/values
        [HttpGet]
        public IActionResult Get()
        {
            var result = TodoService.GetTodos();
            return Ok(result);
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        [HttpPost]
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
