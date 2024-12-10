namespace Lab1MAP_BUN
{
    using System;

    public class PrinterTaskRunner : AbstractTaskRunner
    {
        private static readonly string Formatter = "HH.mm";

        public PrinterTaskRunner(TaskRunner taskRunner) : base(taskRunner) { }

        public override void ExecuteOneTask()
        {
            base.ExecuteOneTask();
            Console.WriteLine($"Executat la: {DateTime.Now.ToString(Formatter)}\n");
        }
    }

}