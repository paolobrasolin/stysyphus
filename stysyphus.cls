%\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\RequirePackage { expl3 }% TODO: [2017/07/19]
\RequirePackage { l3keys2e }
\RequirePackage { xparse }

\ProvidesExplClass{stysyphus}
{2023/05/13}
{0.1.0}
{}

\ExplSyntaxOn

%=[ Interface variants ]========================================================

\cs_generate_variant:Nn \prop_set_from_keyval:Nn { NV }
\cs_generate_variant:Nn \tl_if_eq:nnTF { nVTF }

%=[ CLS options parsing ]=======================================================

\keys_define:nn { stysyphus }
{
    target .tl_set:N  = \l_stysyphus_target_tl,
    % target .value_required:n = true,
    % target .initial:n = { article },
    option .tl_set:N  = \l_stysyphus_option_tl,
    %option .initial:n = {},
    meta .tl_set:N  = \l_stysyphus_meta_tl,
}

\ProcessKeysOptions { stysyphus }

\tl_new:N \l_stysyphus_options_prop
\prop_set_from_keyval:NV \l_stysyphus_options_prop \l_stysyphus_option_tl

\tl_new:N \l_stysyphus_meta_prop
\prop_set_from_keyval:NV \l_stysyphus_meta_prop \l_stysyphus_meta_tl

%=[ Target CLS loading ]========================================================

% \PassOptionsToClass { version = last } { scrreprt }

\prop_if_in:NVTF \l_stysyphus_options_prop \l_stysyphus_target_tl
{
    \prop_get:NVN \l_stysyphus_options_prop \l_stysyphus_target_tl \l_tmpa_tl
    \tl_set:Nx \l_tmpb_tl
        { \exp_not:N \LoadClass [ \tl_use:N \l_tmpa_tl ] { \tl_use:N \l_stysyphus_target_tl } }
    \tl_use:N \l_tmpb_tl
}
{ \exp_args:NV \LoadClass \l_stysyphus_target_tl }

%=[ Experimental public API ]===================================================

\NewDocumentEnvironment { stysyphus } { m +b }
{
    \tl_if_eq:nVTF { #1 } \l_stysyphus_target_tl { #2 } {}
} {}

\NewDocumentCommand \inlineStysyphus { m }
{
    \str_case:Nn \l_stysyphus_target_tl { #1 }
}

\NewDocumentCommand { \stysyphusGet } { m }{
    \prop_get:NnN \l_stysyphus_meta_prop { #1 } \l_tmpa_tl
    \tl_use:N \l_tmpa_tl
}

%=[ Metadata: helpers ]=========================================================

\cs_new_protected:Npn \sysyphus_electric_bogaloo:nnn #1#2#3 {
    \tl_if_eq:nVTF { #1 } \l_stysyphus_target_tl {
        \tl_clear:N \l_tmpa_tl
        \prop_get:NnN \l_stysyphus_meta_prop { #2 } \l_tmpa_tl
        \cs_new_protected:Npn \__my_temp_macro:n ##1 {#3}
        \__my_temp_macro:n { \tl_use:N \l_tmpa_tl }
    } {}
}

%=[ Metadata: title ]===========================================================

\prop_get:NnN \l_stysyphus_meta_prop { title } \l_tmpa_tl

\exp_args:Ne \title { \tl_use:N \l_tmpa_tl }

%=[ Metadata: authors ]=========================================================

\prop_get:NnN \l_stysyphus_meta_prop { authors } \l_tmpa_tl
\clist_set:NV \l_tmpa_clist \l_tmpa_tl

\tl_if_eq:nVTF { elsarticle } \l_stysyphus_target_tl {
    \clist_map_inline:Nn \l_tmpa_clist {
        \prop_set_from_keyval:Nn \l_tmpb_prop { #1 }
        \prop_get:NnN \l_tmpb_prop { fullname } \l_tmpb_tl
        \exp_args:Ne \author { \tl_use:N \l_tmpb_tl }
    }
} {}

\tl_if_eq:nVTF { article } \l_stysyphus_target_tl {
    \seq_clear:N \l_tmpa_seq
    \clist_map_inline:Nn \l_tmpa_clist {
        \prop_set_from_keyval:Nn \l_tmpb_prop { #1 }
        \prop_get:NnN \l_tmpb_prop { fullname } \l_tmpb_tl
        \seq_put_right:NV \l_tmpa_seq \l_tmpb_tl
    }
    \exp_args:No \author { \seq_use:Nnnn \l_tmpa_seq { \and } { \and } { \and } }
} {}

\tl_if_eq:nVTF { tac } \l_stysyphus_target_tl {
    \seq_clear:N \l_tmpa_seq
    \clist_map_inline:Nn \l_tmpa_clist {
        \prop_set_from_keyval:Nn \l_tmpb_prop { #1 }
        \prop_get:NnN \l_tmpb_prop { fullname } \l_tmpb_tl
        \seq_put_right:NV \l_tmpa_seq \l_tmpb_tl
    }
    \exp_args:Ne \author { \seq_use:Nnnn \l_tmpa_seq { ~and~ } { ,~ } { ,~and~ } }
} {}

%=[ Metadata: abstract ]========================================================

\sysyphus_electric_bogaloo:nnn { elsarticle } { abstract } {
    \AtBeginDocument{
        \exp_args:Ne \abstract { #1 } \endabstract
    }
}

\sysyphus_electric_bogaloo:nnn { tac } { abstract } {
    \let\oldmaketitle\maketitle
    \renewcommand{\maketitle}{
        \oldmaketitle
        \exp_args:Ne \abstract { #1 } \endabstract
    }
}

\sysyphus_electric_bogaloo:nnn { article } { abstract } {
    \let\oldmaketitle\maketitle
    \renewcommand{\maketitle}{
        \oldmaketitle
        \exp_args:Ne \abstract { #1 } \endabstract
    }
}

%=[ TODO ]======================================================================

% lipics-v2021
% \tl_if_eq:nVTF { lipics-v2021 } \l_stysyphus_target_tl {
%     \tl_clear:N \l_tmpa_tl
%     \clist_map_inline:Nn \l_tmpa_clist {
%         \prop_set_from_keyval:Nn \l_tmpb_prop { #1 }
%         \prop_get:NnN \l_tmpb_prop { fullname } \l_tmpb_tl
%         \exp_args:Ne \author { \tl_use:N \l_tmpb_tl }
% } {}

% NOTE: this is a better override for maketitle
% probably better:
% \cs_set_eq:NN \oldmaketitle \maketitle
% \cs_new_protected:Npn \maketitle {
%     \oldmaketitle % original definition
%     % Append additional code
% }

\ExplSyntaxOff
