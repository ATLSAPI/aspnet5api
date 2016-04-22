using System;
using System.Collections.Generic;
using aspnet5api.Models;

namespace aspnet5api.Services
{
    public class TodoService : ITodoService
    {
        public IEnumerable<Todo> GetTodos()
        {
            return new List<Todo>
            {
                new Todo()
                {
                    Id = Guid.NewGuid(),
                    Item = "Morning School Run",
                    Complete = false
                },
                new Todo()
                {
                    Id = Guid.NewGuid(),
                    Item = "Agile Fundamentals",
                    Complete = false
                }
            };
        }
    }
}