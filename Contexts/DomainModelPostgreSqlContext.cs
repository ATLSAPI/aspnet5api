using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using aspnet5api.Models;
using Microsoft.Data.Entity;

namespace aspnet5api.Contexts
{
    public class DomainModelPostgreSqlContext : DbContext
    {
        public DbSet<Todo> Todos { get; set; }

        // override Onm

    }
}
