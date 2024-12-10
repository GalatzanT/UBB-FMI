namespace Lab1MAP_BUN
{
    using System;
    using System.Threading;

    public class DelayTaskRunner : AbstractTaskRunner
    {
        private static readonly string Formatter = "HH.mm";

        public DelayTaskRunner(TaskRunner taskRunner) : base(taskRunner) { }

        public override void ExecuteOneTask()
        {
            try
            {
                Thread.Sleep(2000); // Pause execution for 1 second
            }
            catch (ThreadInterruptedException e)
            {
                throw new Exception("Thread was interrupted.", e);
            }
            base.ExecuteOneTask();
        }
    }

}