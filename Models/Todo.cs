using System;

namespace aspnet5api.Models {
    public class Todo {

        public Guid Id { get; set; }

        public string Item { get; set; }

        public bool Complete { get; set; }
    }
}