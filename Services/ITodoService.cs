using System.Collections.Generic;
using aspnet5api.Models;

namespace aspnet5api.Services
{
    public interface ITodoService
    {
        IEnumerable<Todo> GetTodos();
    }
}