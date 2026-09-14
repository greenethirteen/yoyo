import Foundation

struct BiologyQuestion: Identifiable, Hashable {
    let id: Int
    let stem: String
    let options: [String]
    let correctIndex: Int
    let topic: String
    let lessonTitle: String
    let lessonBody: String
    let tip: String
}

/// A single exam paper made up of multiple-choice questions.
struct Paper: Identifiable, Hashable {
    let id: Int
    let subject: String
    let code: String
    let session: String
    let paperTitle: String
    let duration: String
    let marks: String
    let questions: [BiologyQuestion]
}

struct DemoPaper {
    static let papers: [Paper] = [biology1, biology2, chemistry1]

    // MARK: Biology · Paper 1 (questions 1–12)
    static let biology1 = Paper(
        id: 1, subject: "Biology", code: "5090/11", session: "May/June 2026",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 1, stem: "Which feature is found in a plant cell but not in an animal cell?", options: ["Cell membrane", "Cytoplasm", "Cellulose cell wall", "Ribosome"], correctIndex: 2, topic: "Cell structure", lessonTitle: "Plant vs animal cells", lessonBody: "Both plant and animal cells have a cell membrane, cytoplasm and ribosomes. Plant cells also have a cellulose cell wall. Many plant cells contain chloroplasts and a large permanent vacuole too.", tip: "Look for the structure that gives plant cells extra support."),
            .init(id: 2, stem: "What is the main function of red blood cells?", options: ["Defence against pathogens", "Transport of oxygen", "Blood clotting", "Production of hormones"], correctIndex: 1, topic: "Transport in humans", lessonTitle: "Red blood cells", lessonBody: "Red blood cells carry oxygen from the lungs to respiring tissues. They contain haemoglobin, which binds reversibly with oxygen. Their biconcave shape increases surface area for gas exchange.", tip: "Think haemoglobin."),
            .init(id: 3, stem: "Which process moves water through a partially permeable membrane from a dilute solution to a more concentrated solution?", options: ["Active transport", "Diffusion", "Osmosis", "Transpiration"], correctIndex: 2, topic: "Movement in and out of cells", lessonTitle: "Osmosis", lessonBody: "Osmosis is the net movement of water molecules from a region of higher water potential to lower water potential through a partially permeable membrane.", tip: "Water + partially permeable membrane = osmosis."),
            .init(id: 4, stem: "Which gas is used by green plants during photosynthesis?", options: ["Carbon dioxide", "Nitrogen", "Oxygen", "Water vapour"], correctIndex: 0, topic: "Photosynthesis", lessonTitle: "Raw materials for photosynthesis", lessonBody: "Photosynthesis uses carbon dioxide and water to make glucose, using light energy absorbed by chlorophyll. Oxygen is released as a product.", tip: "Recall the word equation for photosynthesis."),
            .init(id: 5, stem: "Where does most aerobic respiration occur inside a cell?", options: ["Cell wall", "Mitochondrion", "Nucleus", "Vacuole"], correctIndex: 1, topic: "Respiration", lessonTitle: "Mitochondria and energy", lessonBody: "Mitochondria are the main site of aerobic respiration. Cells that need lots of energy, such as muscle cells, often contain many mitochondria.", tip: "The 'powerhouse' clue points to mitochondria."),
            .init(id: 6, stem: "Which enzyme digests starch?", options: ["Amylase", "Lipase", "Pepsin", "Trypsin"], correctIndex: 0, topic: "Nutrition", lessonTitle: "Digestive enzymes", lessonBody: "Amylase breaks starch into smaller sugars such as maltose. Lipase breaks down fats, while proteases such as pepsin and trypsin digest proteins.", tip: "Amylase sounds like amylose, a component of starch."),
            .init(id: 7, stem: "What happens to the pupil in bright light?", options: ["It gets larger", "It gets smaller", "It changes colour", "It moves towards the lens"], correctIndex: 1, topic: "Coordination and response", lessonTitle: "The pupil reflex", lessonBody: "In bright light, circular muscles in the iris contract and radial muscles relax, making the pupil smaller. This reduces the amount of light entering the eye and helps protect the retina.", tip: "Bright light → less light should enter."),
            .init(id: 8, stem: "Which blood vessel carries blood away from the heart?", options: ["Artery", "Capillary", "Vein", "Venule"], correctIndex: 0, topic: "Circulation", lessonTitle: "Arteries and veins", lessonBody: "Arteries carry blood away from the heart. Veins carry blood towards the heart. Capillaries are tiny exchange vessels connecting the two systems.", tip: "Artery = Away."),
            .init(id: 9, stem: "Which condition is required for seed germination?", options: ["Carbon dioxide", "Light in every species", "Water", "Chlorophyll"], correctIndex: 2, topic: "Plant reproduction", lessonTitle: "Germination", lessonBody: "Most seeds need water, oxygen and a suitable temperature to germinate. Light is required by some species, but it is not a universal requirement.", tip: "Think about what activates enzymes inside the seed."),
            .init(id: 10, stem: "Which statement about a dominant allele is correct?", options: ["It is always more common", "It is expressed in a heterozygote", "It must be beneficial", "It is only found on the X chromosome"], correctIndex: 1, topic: "Inheritance", lessonTitle: "Dominant and recessive alleles", lessonBody: "A dominant allele is expressed in the phenotype when just one copy is present. A recessive allele is usually expressed only when two copies are present.", tip: "Focus on expression, not frequency or usefulness."),
            .init(id: 11, stem: "Which organism is a decomposer?", options: ["Grass", "Hawk", "Mushroom", "Rabbit"], correctIndex: 2, topic: "Ecology", lessonTitle: "Decomposers", lessonBody: "Many fungi and bacteria act as decomposers. They feed on dead organic matter and release mineral ions back into the environment.", tip: "Look for a fungus or bacterium."),
            .init(id: 12, stem: "Which change would usually increase the rate of an enzyme-controlled reaction up to its optimum?", options: ["Lowering substrate concentration", "Increasing temperature", "Removing the enzyme", "Making the solution extremely acidic"], correctIndex: 1, topic: "Enzymes", lessonTitle: "Temperature and enzymes", lessonBody: "Increasing temperature gives molecules more kinetic energy, so enzyme and substrate particles collide more often. Above the optimum, the enzyme's active site begins to lose its shape and activity falls.", tip: "The key phrase is 'up to its optimum'.")
        ]
    )

    // MARK: Biology · Paper 2 (questions 101–108)
    static let biology2 = Paper(
        id: 2, subject: "Biology", code: "5090/12", session: "Oct/Nov 2025",
        paperTitle: "Paper 2 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 101, stem: "Enzymes are biological catalysts. What type of molecule are they made from?", options: ["Proteins", "Lipids", "Carbohydrates", "Nucleic acids"], correctIndex: 0, topic: "Enzymes", lessonTitle: "What enzymes are made of", lessonBody: "Enzymes are proteins that speed up reactions without being used up. Their precise three-dimensional shape, especially the active site, is what makes each enzyme specific to its substrate.", tip: "Enzyme names often end in '-ase', but the material is protein."),
            .init(id: 102, stem: "Which feature of the alveoli increases the rate of gas exchange?", options: ["Thick muscular walls", "A large surface area", "A dry lining", "Few blood capillaries"], correctIndex: 1, topic: "Gas exchange", lessonTitle: "Alveoli and gas exchange", lessonBody: "Alveoli have a very large surface area, thin walls one cell thick, a moist lining and a rich blood supply. Together these give a short diffusion distance and a steep concentration gradient.", tip: "Big surface area + thin walls = fast diffusion."),
            .init(id: 103, stem: "Which organ removes urea from the blood?", options: ["Liver", "Kidney", "Lungs", "Pancreas"], correctIndex: 1, topic: "Excretion", lessonTitle: "Excreting urea", lessonBody: "Urea is made in the liver from excess amino acids. It is then carried in the blood to the kidneys, which filter it out and remove it in urine.", tip: "Liver makes urea; kidney removes it."),
            .init(id: 104, stem: "Water moves up the xylem of a plant mainly because of which process?", options: ["Translocation", "Transpiration pull", "Active transport", "Osmosis in the phloem"], correctIndex: 1, topic: "Transport in plants", lessonTitle: "The transpiration stream", lessonBody: "Water evaporates from the leaves in transpiration. This creates a pull that draws a continuous column of water up through the xylem from the roots.", tip: "Evaporation at the top pulls water up."),
            .init(id: 105, stem: "Which hormone lowers blood glucose concentration?", options: ["Adrenaline", "Insulin", "Glucagon", "Testosterone"], correctIndex: 1, topic: "Hormones", lessonTitle: "Controlling blood glucose", lessonBody: "Insulin is released by the pancreas when blood glucose is high. It causes the liver to convert glucose into glycogen for storage, lowering the concentration in the blood.", tip: "Insulin puts glucose 'in' to storage."),
            .init(id: 106, stem: "Which cells produce antibodies to fight infection?", options: ["Red blood cells", "Lymphocytes", "Platelets", "Nerve cells"], correctIndex: 1, topic: "Disease and immunity", lessonTitle: "Antibodies and lymphocytes", lessonBody: "Lymphocytes are white blood cells that produce antibodies. Antibodies lock onto antigens on pathogens, helping to destroy them and providing future immunity.", tip: "Lymphocytes make the 'locks' for antigens."),
            .init(id: 107, stem: "Which best describes natural selection?", options: ["Organisms choose to change", "The best-adapted organisms survive and reproduce", "All offspring are identical", "Characteristics are always inherited equally"], correctIndex: 1, topic: "Variation and selection", lessonTitle: "Natural selection", lessonBody: "Individuals vary. Those with characteristics best suited to their environment are more likely to survive and reproduce, passing on the useful alleles to the next generation.", tip: "Think 'survival of the best adapted'."),
            .init(id: 108, stem: "Burning fossil fuels adds which gas that contributes most to the enhanced greenhouse effect?", options: ["Oxygen", "Carbon dioxide", "Nitrogen", "Argon"], correctIndex: 1, topic: "Human impact", lessonTitle: "The greenhouse effect", lessonBody: "Burning fossil fuels releases carbon dioxide, a greenhouse gas that traps heat in the atmosphere. Rising levels are linked to global warming and climate change.", tip: "Fossil fuels + carbon = carbon dioxide.")
        ]
    )

    // MARK: Chemistry · Paper 1 (questions 201–208)
    static let chemistry1 = Paper(
        id: 3, subject: "Chemistry", code: "5070/11", session: "May/June 2026",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 201, stem: "The number of protons in an atom is known as its…", options: ["Mass number", "Atomic number", "Neutron number", "Isotope number"], correctIndex: 1, topic: "Atomic structure", lessonTitle: "Atomic number", lessonBody: "The atomic number is the number of protons in an atom and defines which element it is. The mass number counts protons plus neutrons.", tip: "Protons = atomic number = the element's identity."),
            .init(id: 202, stem: "Which type of bonding holds sodium chloride together?", options: ["Covalent", "Ionic", "Metallic", "Hydrogen"], correctIndex: 1, topic: "Bonding", lessonTitle: "Ionic bonding", lessonBody: "Sodium chloride forms when sodium transfers an electron to chlorine, creating oppositely charged ions. The strong electrostatic attraction between these ions is ionic bonding.", tip: "Metal + non-metal usually means ionic."),
            .init(id: 203, stem: "What is the approximate pH of a strong acid?", options: ["Exactly 7", "Below 7", "Above 7", "Exactly 14"], correctIndex: 1, topic: "Acids and bases", lessonTitle: "The pH scale", lessonBody: "Acids have a pH below 7, with strong acids close to 0–1. Neutral solutions are pH 7 and alkalis are above 7.", tip: "Acid = below 7; alkali = above 7."),
            .init(id: 204, stem: "How does the reactivity of Group I metals change going down the group?", options: ["It decreases", "It increases", "It stays the same", "It increases then decreases"], correctIndex: 1, topic: "The Periodic Table", lessonTitle: "Group I reactivity", lessonBody: "Going down Group I, the outer electron is further from the nucleus and more easily lost, so the metals become more reactive.", tip: "Further from the nucleus = easier to lose the electron."),
            .init(id: 205, stem: "What is the relative formula mass of water, H₂O? (Aᵣ: H = 1, O = 16)", options: ["16", "17", "18", "20"], correctIndex: 2, topic: "Stoichiometry", lessonTitle: "Relative formula mass", lessonBody: "Add the relative atomic masses of every atom: two hydrogens (2 × 1) plus one oxygen (16) gives 18.", tip: "Count every atom, then add the masses."),
            .init(id: 206, stem: "Increasing which factor generally increases the rate of a reaction?", options: ["Lower temperature", "Larger particle size", "Higher concentration", "Removing the catalyst"], correctIndex: 2, topic: "Rates of reaction", lessonTitle: "Speeding up reactions", lessonBody: "Higher concentration means more particles in the same volume, so collisions happen more often and the reaction speeds up. Higher temperature, smaller particles and catalysts also increase rate.", tip: "More frequent collisions = faster reaction."),
            .init(id: 207, stem: "During electrolysis, positively charged ions move towards the…", options: ["Anode", "Cathode", "Electrolyte", "Battery"], correctIndex: 1, topic: "Electrolysis", lessonTitle: "Electrolysis basics", lessonBody: "Positive ions (cations) are attracted to the negative electrode, the cathode. Negative ions move to the positive electrode, the anode.", tip: "Cations (positive) go to the cathode (negative)."),
            .init(id: 208, stem: "What is the general formula for the alkanes?", options: ["CₙH₂ₙ", "CₙH₂ₙ₊₂", "CₙH₂ₙ₋₂", "CₙHₙ"], correctIndex: 1, topic: "Organic chemistry", lessonTitle: "The alkane series", lessonBody: "Alkanes are saturated hydrocarbons with only single bonds. They follow the general formula CₙH₂ₙ₊₂, such as methane CH₄ and ethane C₂H₆.", tip: "Alkanes are saturated: CₙH₂ₙ₊₂.")
        ]
    )
}

// MARK: - Written (short-answer) papers

/// A single short-answer / structured exam question that a student writes out.
struct WrittenQuestion: Identifiable, Hashable {
    let id: Int
    let number: Int
    let stem: String
    let marks: Int
    /// The marking points an examiner looks for, used to guide AI grading.
    let markScheme: [String]
    /// A model answer shown for self-marking when AI grading is unavailable.
    let exemplar: String
}

/// An exam paper made up of written, examiner-marked questions.
struct WrittenPaper: Identifiable, Hashable {
    let id: Int
    let subject: String
    let code: String
    let session: String
    let paperTitle: String
    let duration: String
    let questions: [WrittenQuestion]

    var totalMarks: Int { questions.reduce(0) { $0 + $1.marks } }
}

extension DemoPaper {
    /// Written short-answer papers, graded on-device by the AI examiner.
    static let writtenPapers: [WrittenPaper] = [biologyWritten]

    // MARK: Biology · Structured (short answer)
    static let biologyWritten = WrittenPaper(
        id: 901, subject: "Biology", code: "5090/22", session: "Oct/Nov 2025",
        paperTitle: "Paper 2 Theory", duration: "45 min",
        questions: [
            .init(id: 9001, number: 1,
                  stem: "Describe how the structure of an alveolus is adapted for efficient gas exchange.",
                  marks: 3,
                  markScheme: [
                    "Large surface area (many alveoli) for exchange",
                    "Walls one cell thick / thin walls give a short diffusion distance",
                    "Moist lining so gases can dissolve",
                    "Rich blood supply / many capillaries maintains a steep concentration gradient"
                  ],
                  exemplar: "Alveoli provide a very large surface area and their walls are only one cell thick, giving a short diffusion distance. The moist lining lets oxygen and carbon dioxide dissolve, and a rich supply of blood capillaries keeps a steep concentration gradient so diffusion stays fast."),
            .init(id: 9002, number: 2,
                  stem: "Explain how water travels from the roots of a plant to its leaves.",
                  marks: 4,
                  markScheme: [
                    "Water enters root hair cells by osmosis",
                    "Water moves across the root into the xylem",
                    "Xylem vessels carry water up the stem",
                    "Transpiration (evaporation from the leaves) creates a pull / tension",
                    "Cohesion between water molecules keeps a continuous column"
                  ],
                  exemplar: "Water enters the root hair cells by osmosis and passes across the root into the xylem. Evaporation of water from the leaves during transpiration creates a pull that draws water up the xylem. Because water molecules stick together by cohesion, a continuous column is pulled all the way from the roots to the leaves."),
            .init(id: 9003, number: 3,
                  stem: "Describe the role of insulin in the control of blood glucose concentration.",
                  marks: 3,
                  markScheme: [
                    "Insulin is secreted by the pancreas",
                    "Released when blood glucose concentration is too high",
                    "Causes the liver (and muscles) to convert glucose into glycogen",
                    "This lowers the blood glucose concentration back to normal"
                  ],
                  exemplar: "Insulin is a hormone released by the pancreas when blood glucose concentration rises too high. It makes the liver and muscle cells take up glucose and convert it into glycogen for storage, which lowers the blood glucose concentration back towards normal."),
            .init(id: 9004, number: 4,
                  stem: "Explain how a population of bacteria can become resistant to an antibiotic through natural selection.",
                  marks: 4,
                  markScheme: [
                    "Variation exists in the population, caused by mutation",
                    "Some bacteria are resistant to the antibiotic by chance",
                    "The antibiotic kills the non-resistant bacteria (selection pressure)",
                    "Resistant bacteria survive and reproduce",
                    "The resistance allele is passed on, so its frequency increases over generations"
                  ],
                  exemplar: "Random mutations produce variation, so a few bacteria are resistant to the antibiotic by chance. When the antibiotic is used it kills the non-resistant bacteria but the resistant ones survive. These survivors reproduce and pass on the resistance allele, so over many generations the proportion of resistant bacteria in the population increases."),
            .init(id: 9005, number: 5,
                  stem: "State two structural features of an artery and explain how each is related to its function.",
                  marks: 3,
                  markScheme: [
                    "Thick, muscular / elastic wall — withstands and maintains high blood pressure",
                    "Wall can stretch and recoil — smooths out the pulsed flow of blood",
                    "Narrow lumen (relative to wall) — helps keep the blood pressure high",
                    "No valves needed — pressure keeps blood flowing in one direction"
                  ],
                  exemplar: "Arteries have thick, muscular and elastic walls that can withstand the high pressure of blood leaving the heart and recoil to keep the blood moving. They also have a relatively narrow lumen, which helps maintain that high pressure as blood is carried away from the heart.")
        ]
    )
}
