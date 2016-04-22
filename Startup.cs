using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using aspnet5api.Services;
using Swashbuckle.SwaggerGen;
using Swashbuckle.SwaggerGen.XmlComments;

namespace aspnet5api
{
    public class Startup
    {
        public Startup(IHostingEnvironment env)
        {
            // Set up configuration sources.
            var builder = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .AddEnvironmentVariables();
            Configuration = builder.Build();
        }

        public IConfigurationRoot Configuration { get; set; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Add framework services.
            services.AddMvc();
            services.AddTransient<ITodoService, TodoService>();
            services.AddSwaggerGen();

            var pathToDoc = Configuration["Swagger:Path"];

            services.ConfigureSwaggerDocument(c =>
            {
                c.SingleApiVersion(new Info
                {
                    Version = "v1",
                    Title = "AspNet5 API",
                    Description = "A simple api to kickstart .net core development",
                    TermsOfService = "None"
                });
                // c.OperationFilter(new ApplyXmlActionComments(pathToDoc));

            });

            services.ConfigureSwaggerSchema(c =>
            {
                c.DescribeAllEnumsAsStrings = true;
                // c.ModelFilter(new ApplyXmlTypeComments(pathToDoc));
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();

            app.UseIISPlatformHandler();

            app.UseStaticFiles();

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Index}/{id?}");
            });
            app.UseSwaggerGen();
            app.UseSwaggerUi();
        }

        // Entry point for the application.
        public static void Main(string[] args) => Microsoft.AspNet.Hosting.WebApplication.Run<Startup>(args);
    }
}
