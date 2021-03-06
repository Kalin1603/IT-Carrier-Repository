﻿namespace P01__OneToOne
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Text;

    public class Person
    {

        [Key]
        public int Id { get; set; }

        [Required]
        public string FirstName { get; set; }

        [Required]
        public string LastName { get; set; }

        public decimal Salary { get; set; }

        [ForeignKey(nameof(Passport))]
        public int PassportId { get; set; }

        public virtual Passport Passport { get; set; }
    }
}
