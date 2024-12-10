namespace Lab1MAP_BUN
{
    using System;

    public class MessageClass : Task
    {
        private string message, from, to, description;
        private DateTime date;

        private static readonly string Formatter = "yyyy-MM-dd HH:mm";

        public MessageClass(string taskID, string description, string message, string from, string to, DateTime date)
            : base(taskID)
        {
            this.description = description;
            this.message = message;
            this.from = from;
            this.to = to;
            this.date = date;
        }

        public override string ToString()
        {
            return $"Task Description: {description} " +
                   $"Message: {message} " +
                   $"From: {from} " +
                   $"To: {to} " +
                   $"Date: {date.ToString(Formatter)}";
        }

        public override void Execute()
        {
            Console.WriteLine($"{date.ToString(Formatter)}: {message}");
        }
    }

}