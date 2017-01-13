//-----------------------------------------------------------------------
// <copyright file="CodeGenerationResult.cs" company="Ollon, LLC">
//     Copyright (c) 2017 Ollon, LLC. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;
using System.CodeDom;
using System.Xml.Linq;

namespace MSBuild.Tasks.Tasks.Generator
{
    internal struct CodeGenerationResult
    {
        public CodeGenerationResult(bool success, CompilationUnitSyntax unit) : this()
        {
            Success = success;
            Unit = unit;
        }

        public CodeGenerationResult(bool success, XmlElementSyntax vsct) : this()
        {
            Success = success;
            Vsct = vsct;
        }

        public bool Success { get; }
        public XmlElementSyntax Vsct { get; }
        public CompilationUnitSyntax Unit { get; }

    }
}