/* Generated By:JavaCC: Do not edit this line. MarkersParser.java */
package cn.ac.ios.iscasmc.papersprojects.backend.parser.marker;

import java.lang.StringBuilder;

public final class MarkersParser implements MarkersParserConstants {
        public String parseMarkers() {
                try {
                        return actualParser();
                } catch (ParseException pe) {
                        return null;
                }
        }

  final private String actualParser() throws ParseException {
        Token t;
        StringBuilder sb = new StringBuilder();
    label_1:
    while (true) {
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case A_ACUTE_UC:
        jj_consume_token(A_ACUTE_UC);
                                 sb.append("\u00c1");
        break;
      case A_ACUTE_LC:
        jj_consume_token(A_ACUTE_LC);
                                 sb.append("\u00e1");
        break;
      case A_GRAVE_UC:
        jj_consume_token(A_GRAVE_UC);
                                 sb.append("\u00c0");
        break;
      case A_GRAVE_LC:
        jj_consume_token(A_GRAVE_LC);
                                 sb.append("\u00e0");
        break;
      case E_ACUTE_UC:
        jj_consume_token(E_ACUTE_UC);
                                 sb.append("\u00c9");
        break;
      case E_ACUTE_LC:
        jj_consume_token(E_ACUTE_LC);
                                 sb.append("\u00e9");
        break;
      case E_GRAVE_UC:
        jj_consume_token(E_GRAVE_UC);
                                 sb.append("\u00c8");
        break;
      case E_GRAVE_LC:
        jj_consume_token(E_GRAVE_LC);
                                 sb.append("\u00e8");
        break;
      case I_ACUTE_UC:
        jj_consume_token(I_ACUTE_UC);
                                 sb.append("\u00cd");
        break;
      case I_ACUTE_LC:
        jj_consume_token(I_ACUTE_LC);
                                 sb.append("\u0131\u0301");
        break;
      case I_GRAVE_UC:
        jj_consume_token(I_GRAVE_UC);
                                 sb.append("\u00cc");
        break;
      case I_GRAVE_LC:
        jj_consume_token(I_GRAVE_LC);
                                 sb.append("\u0131\u0300");
        break;
      case O_ACUTE_UC:
        jj_consume_token(O_ACUTE_UC);
                                 sb.append("\u00d3");
        break;
      case O_ACUTE_LC:
        jj_consume_token(O_ACUTE_LC);
                                 sb.append("\u00f3");
        break;
      case O_GRAVE_UC:
        jj_consume_token(O_GRAVE_UC);
                                 sb.append("\u00d2");
        break;
      case O_GRAVE_LC:
        jj_consume_token(O_GRAVE_LC);
                                 sb.append("\u00f2");
        break;
      case U_ACUTE_UC:
        jj_consume_token(U_ACUTE_UC);
                                 sb.append("\u00da");
        break;
      case U_ACUTE_LC:
        jj_consume_token(U_ACUTE_LC);
                                 sb.append("\u00fa");
        break;
      case U_GRAVE_UC:
        jj_consume_token(U_GRAVE_UC);
                                 sb.append("\u00d9");
        break;
      case U_GRAVE_LC:
        jj_consume_token(U_GRAVE_LC);
                                 sb.append("\u00f9");
        break;
      case U_UML_UC:
        jj_consume_token(U_UML_UC);
                               sb.append("\u00dc");
        break;
      case U_UML_LC:
        jj_consume_token(U_UML_LC);
                               sb.append("\u00fc");
        break;
      case ALPHA_LC:
        jj_consume_token(ALPHA_LC);
                               sb.append("\u03b1");
        break;
      case BETA_LC:
        jj_consume_token(BETA_LC);
                              sb.append("\u03b2");
        break;
      case GAMMA_LC:
        jj_consume_token(GAMMA_LC);
                               sb.append("\u03b3");
        break;
      case DELTA_LC:
        jj_consume_token(DELTA_LC);
                               sb.append("\u03b4");
        break;
      case EPSILON_LC:
        jj_consume_token(EPSILON_LC);
                                 sb.append("\u03b5");
        break;
      case VAREPSILON_LC:
        jj_consume_token(VAREPSILON_LC);
                                    sb.append("\u03b5");
        break;
      case ZETA_LC:
        jj_consume_token(ZETA_LC);
                              sb.append("\u03b6");
        break;
      case ETA_LC:
        jj_consume_token(ETA_LC);
                             sb.append("\u03b7");
        break;
      case THETA_LC:
        jj_consume_token(THETA_LC);
                               sb.append("\u03b8");
        break;
      case VARTHETA_LC:
        jj_consume_token(VARTHETA_LC);
                                  sb.append("\u03b8");
        break;
      case IOTA_LC:
        jj_consume_token(IOTA_LC);
                              sb.append("\u03b9");
        break;
      case KAPPA_LC:
        jj_consume_token(KAPPA_LC);
                               sb.append("\u03ba");
        break;
      case LAMBDA_LC:
        jj_consume_token(LAMBDA_LC);
                                sb.append("\u03bb");
        break;
      case MU_LC:
        jj_consume_token(MU_LC);
                            sb.append("\u03bc");
        break;
      case NU_LC:
        jj_consume_token(NU_LC);
                            sb.append("\u03bd");
        break;
      case XI_LC:
        jj_consume_token(XI_LC);
                            sb.append("\u03be");
        break;
      case PI_LC:
        jj_consume_token(PI_LC);
                            sb.append("\u03c0");
        break;
      case VARPI_LC:
        jj_consume_token(VARPI_LC);
                               sb.append("\u03c0");
        break;
      case RHO_LC:
        jj_consume_token(RHO_LC);
                             sb.append("\u03c1");
        break;
      case VARRHO_LC:
        jj_consume_token(VARRHO_LC);
                                sb.append("\u03c1");
        break;
      case SIGMA_LC:
        jj_consume_token(SIGMA_LC);
                               sb.append("\u03c3");
        break;
      case VARSIGMA_LC:
        jj_consume_token(VARSIGMA_LC);
                                  sb.append("\u03c2");
        break;
      case TAU_LC:
        jj_consume_token(TAU_LC);
                             sb.append("\u03c4");
        break;
      case UPSILON_LC:
        jj_consume_token(UPSILON_LC);
                                 sb.append("\u03c5");
        break;
      case PHI_LC:
        jj_consume_token(PHI_LC);
                             sb.append("\u03c6");
        break;
      case VARPHI_LC:
        jj_consume_token(VARPHI_LC);
                                sb.append("\u03c6");
        break;
      case CHI_LC:
        jj_consume_token(CHI_LC);
                             sb.append("\u03c7");
        break;
      case PSI_LC:
        jj_consume_token(PSI_LC);
                             sb.append("\u03c8");
        break;
      case OMEGA_LC:
        jj_consume_token(OMEGA_LC);
                               sb.append("\u03c9");
        break;
      case GAMMA_UC:
        jj_consume_token(GAMMA_UC);
                               sb.append("\u0393");
        break;
      case VARGAMMA_UC:
        jj_consume_token(VARGAMMA_UC);
                                  sb.append("\u0393");
        break;
      case DELTA_UC:
        jj_consume_token(DELTA_UC);
                               sb.append("\u2206");
        break;
      case VARDELTA_UC:
        jj_consume_token(VARDELTA_UC);
                                  sb.append("\u2206");
        break;
      case THETA_UC:
        jj_consume_token(THETA_UC);
                               sb.append("\u0398");
        break;
      case VARTHETA_UC:
        jj_consume_token(VARTHETA_UC);
                                  sb.append("\u0398");
        break;
      case LAMBDA_UC:
        jj_consume_token(LAMBDA_UC);
                                sb.append("\u039b");
        break;
      case VARLAMBDA_UC:
        jj_consume_token(VARLAMBDA_UC);
                                   sb.append("\u039b");
        break;
      case XI_UC:
        jj_consume_token(XI_UC);
                            sb.append("\u039e");
        break;
      case VARXI_UC:
        jj_consume_token(VARXI_UC);
                               sb.append("\u039e");
        break;
      case PI_UC:
        jj_consume_token(PI_UC);
                            sb.append("\u03a0");
        break;
      case VARPI_UC:
        jj_consume_token(VARPI_UC);
                               sb.append("\u03a0");
        break;
      case SIGMA_UC:
        jj_consume_token(SIGMA_UC);
                               sb.append("\u03a3");
        break;
      case VARSIGMA_UC:
        jj_consume_token(VARSIGMA_UC);
                                  sb.append("\u03a3");
        break;
      case UPSILON_UC:
        jj_consume_token(UPSILON_UC);
                                 sb.append("\u03a5");
        break;
      case VARUPSILON_UC:
        jj_consume_token(VARUPSILON_UC);
                                    sb.append("\u03a5");
        break;
      case PHI_UC:
        jj_consume_token(PHI_UC);
                             sb.append("\u03a6");
        break;
      case VARPHI_UC:
        jj_consume_token(VARPHI_UC);
                                sb.append("\u03a6");
        break;
      case PSI_UC:
        jj_consume_token(PSI_UC);
                             sb.append("\u03a8");
        break;
      case VARPSI_UC:
        jj_consume_token(VARPSI_UC);
                                sb.append("\u03a8");
        break;
      case OMEGA_UC:
        jj_consume_token(OMEGA_UC);
                               sb.append("\u03a9");
        break;
      case VAROMEGA_UC:
        jj_consume_token(VAROMEGA_UC);
                                  sb.append("\u03a9");
        break;
      case ESCAPED_BRACKET_OPEN:
        jj_consume_token(ESCAPED_BRACKET_OPEN);
                                           sb.append("{");
        break;
      case ESCAPED_BRACKET_CLOSE:
        jj_consume_token(ESCAPED_BRACKET_CLOSE);
                                            sb.append("}");
        break;
      case BRACKET_OPEN:
        jj_consume_token(BRACKET_OPEN);
        break;
      case BRACKET_CLOSE:
        jj_consume_token(BRACKET_CLOSE);
        break;
      case ESCAPED_DOLLAR:
        jj_consume_token(ESCAPED_DOLLAR);
                                     sb.append("$");
        break;
      case DOLLAR:
        jj_consume_token(DOLLAR);
        break;
      case MATH_FONT:
        jj_consume_token(MATH_FONT);
        break;
      case MATH_TEXT:
        jj_consume_token(MATH_TEXT);
        break;
      case TEXT_FONT:
        jj_consume_token(TEXT_FONT);
        break;
      case EMPH:
        jj_consume_token(EMPH);
        break;
      case OTHER:
        t = jj_consume_token(OTHER);
                                sb.append(t.toString());
        break;
      default:
        jj_la1[0] = jj_gen;
        jj_consume_token(-1);
        throw new ParseException();
      }
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case A_ACUTE_UC:
      case A_ACUTE_LC:
      case A_GRAVE_UC:
      case A_GRAVE_LC:
      case E_ACUTE_UC:
      case E_ACUTE_LC:
      case E_GRAVE_UC:
      case E_GRAVE_LC:
      case I_ACUTE_UC:
      case I_ACUTE_LC:
      case I_GRAVE_UC:
      case I_GRAVE_LC:
      case O_ACUTE_UC:
      case O_ACUTE_LC:
      case O_GRAVE_UC:
      case O_GRAVE_LC:
      case U_ACUTE_UC:
      case U_ACUTE_LC:
      case U_GRAVE_UC:
      case U_GRAVE_LC:
      case U_UML_UC:
      case U_UML_LC:
      case ALPHA_LC:
      case BETA_LC:
      case GAMMA_LC:
      case DELTA_LC:
      case EPSILON_LC:
      case VAREPSILON_LC:
      case ZETA_LC:
      case ETA_LC:
      case THETA_LC:
      case VARTHETA_LC:
      case IOTA_LC:
      case KAPPA_LC:
      case LAMBDA_LC:
      case MU_LC:
      case NU_LC:
      case XI_LC:
      case PI_LC:
      case VARPI_LC:
      case RHO_LC:
      case VARRHO_LC:
      case SIGMA_LC:
      case VARSIGMA_LC:
      case TAU_LC:
      case UPSILON_LC:
      case PHI_LC:
      case VARPHI_LC:
      case CHI_LC:
      case PSI_LC:
      case OMEGA_LC:
      case GAMMA_UC:
      case VARGAMMA_UC:
      case DELTA_UC:
      case VARDELTA_UC:
      case THETA_UC:
      case VARTHETA_UC:
      case LAMBDA_UC:
      case VARLAMBDA_UC:
      case XI_UC:
      case VARXI_UC:
      case PI_UC:
      case VARPI_UC:
      case SIGMA_UC:
      case VARSIGMA_UC:
      case UPSILON_UC:
      case VARUPSILON_UC:
      case PHI_UC:
      case VARPHI_UC:
      case PSI_UC:
      case VARPSI_UC:
      case OMEGA_UC:
      case VAROMEGA_UC:
      case ESCAPED_BRACKET_OPEN:
      case ESCAPED_BRACKET_CLOSE:
      case BRACKET_OPEN:
      case BRACKET_CLOSE:
      case ESCAPED_DOLLAR:
      case DOLLAR:
      case MATH_FONT:
      case MATH_TEXT:
      case TEXT_FONT:
      case EMPH:
      case OTHER:
        ;
        break;
      default:
        jj_la1[1] = jj_gen;
        break label_1;
      }
    }
    jj_consume_token(0);
                {if (true) return sb.toString();}
    throw new Error("Missing return statement in function");
  }

  /** Generated Token Manager. */
  public MarkersParserTokenManager token_source;
  SimpleCharStream jj_input_stream;
  /** Current token. */
  public Token token;
  /** Next token. */
  public Token jj_nt;
  private int jj_ntk;
  private int jj_gen;
  final private int[] jj_la1 = new int[2];
  static private int[] jj_la1_0;
  static private int[] jj_la1_1;
  static private int[] jj_la1_2;
  static {
      jj_la1_init_0();
      jj_la1_init_1();
      jj_la1_init_2();
   }
   private static void jj_la1_init_0() {
      jj_la1_0 = new int[] {0xfffffffe,0xfffffffe,};
   }
   private static void jj_la1_init_1() {
      jj_la1_1 = new int[] {0xffffffff,0xffffffff,};
   }
   private static void jj_la1_init_2() {
      jj_la1_2 = new int[] {0x1fffff,0x1fffff,};
   }

  /** Constructor with InputStream. */
  public MarkersParser(java.io.InputStream stream) {
     this(stream, null);
  }
  /** Constructor with InputStream and supplied encoding */
  public MarkersParser(java.io.InputStream stream, String encoding) {
    try { jj_input_stream = new SimpleCharStream(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source = new MarkersParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 2; i++) jj_la1[i] = -1;
  }

  /** Reinitialise. */
  public void ReInit(java.io.InputStream stream) {
     ReInit(stream, null);
  }
  /** Reinitialise. */
  public void ReInit(java.io.InputStream stream, String encoding) {
    try { jj_input_stream.ReInit(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 2; i++) jj_la1[i] = -1;
  }

  /** Constructor. */
  public MarkersParser(java.io.Reader stream) {
    jj_input_stream = new SimpleCharStream(stream, 1, 1);
    token_source = new MarkersParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 2; i++) jj_la1[i] = -1;
  }

  /** Reinitialise. */
  public void ReInit(java.io.Reader stream) {
    jj_input_stream.ReInit(stream, 1, 1);
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 2; i++) jj_la1[i] = -1;
  }

  /** Constructor with generated Token Manager. */
  public MarkersParser(MarkersParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 2; i++) jj_la1[i] = -1;
  }

  /** Reinitialise. */
  public void ReInit(MarkersParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 2; i++) jj_la1[i] = -1;
  }

  private Token jj_consume_token(int kind) throws ParseException {
    Token oldToken;
    if ((oldToken = token).next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    if (token.kind == kind) {
      jj_gen++;
      return token;
    }
    token = oldToken;
    jj_kind = kind;
    throw generateParseException();
  }


/** Get the next Token. */
  final public Token getNextToken() {
    if (token.next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    jj_gen++;
    return token;
  }

/** Get the specific Token. */
  final public Token getToken(int index) {
    Token t = token;
    for (int i = 0; i < index; i++) {
      if (t.next != null) t = t.next;
      else t = t.next = token_source.getNextToken();
    }
    return t;
  }

  private int jj_ntk() {
    if ((jj_nt=token.next) == null)
      return (jj_ntk = (token.next=token_source.getNextToken()).kind);
    else
      return (jj_ntk = jj_nt.kind);
  }

  private java.util.List<int[]> jj_expentries = new java.util.ArrayList<int[]>();
  private int[] jj_expentry;
  private int jj_kind = -1;

  /** Generate ParseException. */
  public ParseException generateParseException() {
    jj_expentries.clear();
    boolean[] la1tokens = new boolean[85];
    if (jj_kind >= 0) {
      la1tokens[jj_kind] = true;
      jj_kind = -1;
    }
    for (int i = 0; i < 2; i++) {
      if (jj_la1[i] == jj_gen) {
        for (int j = 0; j < 32; j++) {
          if ((jj_la1_0[i] & (1<<j)) != 0) {
            la1tokens[j] = true;
          }
          if ((jj_la1_1[i] & (1<<j)) != 0) {
            la1tokens[32+j] = true;
          }
          if ((jj_la1_2[i] & (1<<j)) != 0) {
            la1tokens[64+j] = true;
          }
        }
      }
    }
    for (int i = 0; i < 85; i++) {
      if (la1tokens[i]) {
        jj_expentry = new int[1];
        jj_expentry[0] = i;
        jj_expentries.add(jj_expentry);
      }
    }
    int[][] exptokseq = new int[jj_expentries.size()][];
    for (int i = 0; i < jj_expentries.size(); i++) {
      exptokseq[i] = jj_expentries.get(i);
    }
    return new ParseException(token, exptokseq, tokenImage);
  }

  /** Enable tracing. */
  final public void enable_tracing() {
  }

  /** Disable tracing. */
  final public void disable_tracing() {
  }

}
