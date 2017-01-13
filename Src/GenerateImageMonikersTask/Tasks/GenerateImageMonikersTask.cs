//-----------------------------------------------------------------------
// <copyright file="GenerateImageMonikers.cs" company="Ollon, LLC">
// Copyright (c) 2017 Ollon, LLC.  All Rights Reserved.
// </copyright>
//-----------------------------------------------------------------------

using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using MSBuild.Tasks.Tasks.Generator;
using System;
using System.IO;
using System.Xml;
using System.Xml.Serialization;

namespace MSBuild.Tasks.Tasks
{
    public class GenerateImageMonikersTask : Task
    {


        public string Namespace { get; set; } = "Ollon.VisualStudio.Imaging";
        public string MonikerClass { get; set; } = "ImageMonikers";

        public string ImageIdClass { get; set; } = "ImageIds";

        public string ClassAccess { get; set; } = "public";

        public string Language { get; set; } = "CSharp";

        [Required]
        public string ImageManifestFile { get; set; }

        [Required]
        public string TargetDirectory { get; set; }

        [Output]
        public string ImageIdFile { get; set; }

        [Output]
        public string MonikerFile { get; set; }

        internal static class Defaults
        {
            public const string ClassAccess = "Public";
            public const string ImageIdClass = "MyImageIds";
            public const string MonikerClass = "MyMonikers";
            public const string Namespace = "MyImages";
        }

        public override bool Execute()
        {
            ICodeGenerator generator = CodeGeneratorFactory.Create(this.Log, Language == "CSharp" ? Tasks.Language.CSharp : Tasks.Language.Vsct);

            generator.GenerateCode(CreateContext());

            return true;
        }

        internal CodeGenerationContext CreateContext()
        {
            ImageIdFile = Path.Combine(TargetDirectory, $"{MonikerClass}.cs");
            MonikerFile = Path.Combine(TargetDirectory, $"{ImageIdClass}.cs");

            return new CodeGenerationContext(
                LoadManifest(ImageManifestFile),
                Namespace,
                MonikerClass,
                MonikerFile,
                ImageIdClass,
                ImageIdFile,
                ClassAccess
                );
        }

        internal static ImageManifest LoadManifest(string manifestName)
        {
            using (FileStream fileStream = File.OpenRead(manifestName))
            {
                try
                {
                    XmlReaderSettings settings = new XmlReaderSettings()
                    {
                        DtdProcessing = DtdProcessing.Prohibit,
                        XmlResolver = null
                    };
                    using (XmlReader xmlReader = XmlReader.Create(fileStream, settings))
                        return (ImageManifest)new XmlSerializer(typeof(ImageManifest)).Deserialize(xmlReader);
                }
                catch
                {
                    throw;
                }
            }
        }
    }
}